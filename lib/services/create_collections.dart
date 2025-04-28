import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createFakeGymData() async {
  final firestore = FirebaseFirestore.instance;

  // 1. Crear roles
  await Future.wait([
    firestore.collection('roles').doc('cliente').set({
      'name': 'Cliente',
      'description': 'Accede a entrenamientos y seguimiento personal.',
    }),
    firestore.collection('roles').doc('entrenador').set({
      'name': 'Entrenador',
      'description': 'Crea y asigna rutinas personalizadas a usuarios.',
    }),
    firestore.collection('roles').doc('secretario').set({
      'name': 'Secretario',
      'description': 'Gestiona membresías y asistencias de usuarios.',
    }),
    firestore.collection('roles').doc('dueño').set({
      'name': 'Dueño',
      'description': 'Administra todo el sistema, reportes y usuarios.',
    }),
  ]);

  // 2. Crear membresías
  final membershipRef = firestore.collection('memberships').doc('plan_mensual');
  await membershipRef.set({
    'name': 'Plan Mensual',
    'price': 30.0,
    'durationDays': 30,
    'description': 'Acceso ilimitado durante 30 días.',
    'createdAt': DateTime.now().toIso8601String(),
  });

  // 3. Crear usuario fake
  final fakeUserId = 'fakeUser123';
  final userRef = firestore.collection('users').doc(fakeUserId);
  await userRef.set({
    'name': 'Juan Pérez',
    'email': 'juanperez@example.com',
    'phone': '555-1234',
    'roles': ['cliente'],
    'membershipId': 'plan_mensual',
    'height': 175,
    'weight': 72,
    'dateOfBirth': '1995-06-15',
    'profilePictureUrl': null,
  });

  // 4. Crear suscripción
  await firestore.collection('subscriptions').add({
    'userId': fakeUserId,
    'membershipId': 'plan_mensual',
    'startDate': DateTime.now().toIso8601String(),
    'endDate': DateTime.now().add(Duration(days: 30)).toIso8601String(),
    'status': 'active',
    'paymentAmount': 30.0,
    'paymentDate': DateTime.now().toIso8601String(),
    'notificationSent': false,
  });

  // 5. Crear asistencia
  await firestore.collection('attendances').add({
    'userId': fakeUserId,
    'date': DateTime.now().toIso8601String(),
    'checkInTime': DateTime.now(),
    'checkOutTime': DateTime.now().add(Duration(hours: 2)),
  });

  // 6. Crear workout
  await firestore.collection('workouts').add({
    'userId': fakeUserId,
    'title': 'Rutina de Pecho',
    'description': 'Rutina básica de fuerza para pectorales.',
    'exercises': [
      {
        'name': 'Bench Press',
        'repetitions': 12,
        'sets': 4,
        'videoUrl': 'https://example.com/benchpress',
      },
      {
        'name': 'Incline Dumbbell Press',
        'repetitions': 10,
        'sets': 3,
        'videoUrl': null,
      },
    ],
  });

  // 7. Crear progreso
  await firestore.collection('progress').add({
    'userId': fakeUserId,
    'week': 1,
    'weightLiftedKg': 80.0,
    'repetitionsAchieved': 12,
    'bodyChangeNotes': 'Incremento leve en fuerza del tren superior.',
  });

  // 8. Crear clase
  await firestore.collection('classes').add({
    'name': 'Clase de Spinning',
    'instructorId': 'fakeTrainer456',
    'date': DateTime.now().add(Duration(days: 3)).toIso8601String(),
    'startTime': '18:00',
    'endTime': '19:00',
    'capacity': 15,
    'attendees': [fakeUserId],
  });

  print('🎯 Datos fake creados exitosamente en Firestore.');
}
