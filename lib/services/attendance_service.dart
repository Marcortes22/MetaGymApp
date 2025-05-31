import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance.dart';
import '../services/subscription_service.dart';

class AttendanceService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'attendances',
  );
  final SubscriptionService _subscriptionService = SubscriptionService();

  Future<void> register(Attendance attendance) async {
    await _collection.add(attendance.toMap());
  }

  Future<List<Attendance>> getByUser(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();
    return snapshot.docs
        .map(
          (doc) =>
              Attendance.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  /// Check if user has already checked in today
  Future<bool> hasCheckedInToday(String userId) async {
    // Get start and end of today
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Query for attendance records for this user today
    final snapshot =
        await _collection
            .where('userId', isEqualTo: userId)
            .where('date', isGreaterThanOrEqualTo: startOfDay)
            .where('date', isLessThanOrEqualTo: endOfDay)
            .limit(1)
            .get();

    return snapshot.docs.isNotEmpty;
  }

  // Check if user has admin roles (coa, own, sec)
  Future<bool> hasAdminRole(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      return false;
    }

    final userData = userDoc.data() as Map<String, dynamic>;
    final roles = List<Map<String, dynamic>>.from(userData['roles'] ?? []);

    // Check if user has any admin role
    for (var role in roles) {
      final roleId = role['id'] as String;
      if (roleId == 'coa' || roleId == 'own' || roleId == 'sec') {
        return true;
      }
    }

    return false;
  }

  // Check if user is only a client (cli role only)
  Future<bool> isClientOnly(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      return false;
    }

    final userData = userDoc.data() as Map<String, dynamic>;
    final roles = List<Map<String, dynamic>>.from(userData['roles'] ?? []);

    if (roles.isEmpty) {
      return false;
    }

    // Check if user has only client role
    bool hasClientRole = false;
    for (var role in roles) {
      final roleId = role['id'] as String;
      if (roleId != 'cli') {
        return false; // Has some other role
      } else {
        hasClientRole = true;
      }
    }

    return hasClientRole; // Only has client role
  }

  // Get subscription status info
  Future<Map<String, dynamic>> getSubscriptionInfo(String userId) async {
    final hasValidSubscription = await _subscriptionService
        .hasValidSubscription(userId);
    final daysRemaining = await _subscriptionService
        .getDaysRemainingInSubscription(userId);

    return {'isValid': hasValidSubscription, 'daysRemaining': daysRemaining};
  }

  // Check-in with PIN code
  Future<Map<String, dynamic>> checkInWithPin(String pin) async {
    try {
      // Find user with this PIN
      final userQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('pin', isEqualTo: pin)
              .limit(1)
              .get();

      if (userQuery.docs.isEmpty) {
        return {'success': false, 'message': 'PIN no válido'};
      }

      final userId = userQuery.docs.first.id;

      // Check if user already checked in today
      if (await hasCheckedInToday(userId)) {
        return {
          'success': false,
          'message': 'Ya registraste tu asistencia hoy',
        };
      }

      // Check if user is client-only or has admin roles
      final isClientOnly = await this.isClientOnly(userId);

      if (isClientOnly) {
        // Client needs to have a valid subscription
        final subscriptionInfo = await getSubscriptionInfo(userId);

        if (!subscriptionInfo['isValid']) {
          return {
            'success': false,
            'message':
                'Su suscripción ha expirado. Por favor renueve su membresía.',
          };
        }

        // Check if subscription is about to expire
        final daysRemaining = subscriptionInfo['daysRemaining'];
        if (daysRemaining <= 5) {
          // Register attendance but warn about expiration
          final attendance = Attendance(
            id: '',
            userId: userId,
            date: DateTime.now(),
            checkInTime: DateTime.now(),
          );

          await register(attendance);

          return {
            'success': true,
            'userId': userId,
            'warning':
                'Su suscripción vence en $daysRemaining día${daysRemaining == 1 ? '' : 's'}',
          };
        }
      }

      // Register attendance for admin users or clients with valid subscriptions
      final attendance = Attendance(
        id: '',
        userId: userId,
        date: DateTime.now(),
        checkInTime: DateTime.now(),
      );

      await register(attendance);
      return {'success': true, 'userId': userId};
    } catch (e) {
      print('Error checking in with PIN: $e');
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Check-in with QR code
  Future<Map<String, dynamic>> checkInWithQR(String qrData) async {
    try {
      // Find user with this QR data
      final userQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('qrCode', isEqualTo: qrData)
              .limit(1)
              .get();

      if (userQuery.docs.isEmpty) {
        return {'success': false, 'message': 'QR no válido'};
      }

      final userId = userQuery.docs.first.id;

      // Check if user already checked in today
      if (await hasCheckedInToday(userId)) {
        return {
          'success': false,
          'message': 'Ya registraste tu asistencia hoy',
        };
      }

      // Check if user is client-only or has admin roles
      final isClientOnly = await this.isClientOnly(userId);

      if (isClientOnly) {
        // Client needs to have a valid subscription
        final subscriptionInfo = await getSubscriptionInfo(userId);

        if (!subscriptionInfo['isValid']) {
          return {
            'success': false,
            'message':
                'Su suscripción ha expirado. Por favor renueve su membresía.',
          };
        }

        // Check if subscription is about to expire
        final daysRemaining = subscriptionInfo['daysRemaining'];
        if (daysRemaining <= 5) {
          // Register attendance but warn about expiration
          final attendance = Attendance(
            id: '',
            userId: userId,
            date: DateTime.now(),
            checkInTime: DateTime.now(),
          );

          await register(attendance);

          return {
            'success': true,
            'userId': userId,
            'warning':
                'Su suscripción vence en $daysRemaining día${daysRemaining == 1 ? '' : 's'}',
          };
        }
      }

      // Register attendance for admin users or clients with valid subscriptions
      final attendance = Attendance(
        id: '',
        userId: userId,
        date: DateTime.now(),
        checkInTime: DateTime.now(),
      );

      await register(attendance);
      return {'success': true, 'userId': userId};
    } catch (e) {
      print('Error in checkInWithQR: $e');
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
