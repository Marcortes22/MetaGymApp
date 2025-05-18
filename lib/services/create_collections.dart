import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createFakeGymData() async {
  final firestore = FirebaseFirestore.instance;

  // 1. Crear roles
  await Future.wait([
    firestore.collection('roles').doc('cli').set({
      // cliente
      'name': 'Client',
      'description': 'Role for regular gym users.',
    }),
    firestore.collection('roles').doc('coa').set({
      // coach
      'name': 'Trainer',
      'description': 'Rol for gym trainers and coaches, can creates routines.',
    }),
    firestore.collection('roles').doc('sec').set({
      // secretary
      'name': 'Secretary',
      'description':
          'Role for gym secretaries, can manage users and memberships.',
    }),
    firestore.collection('roles').doc('own').set({
      // owner
      'name': 'Owner',
      'description': 'Role for gym owners, can manage everything.',
    }),
  ]);

  // 2. Crear membresías
  await Future.wait([
    firestore.collection('memberships').doc('day_plan').set({
      'name': 'Plan Diario',
      'price': 10.0,
      'durationDays': 1,
      'description': 'Acceso ilimitado durante un día.',
      'createdAt': DateTime.now(),
    }),
    firestore.collection('memberships').doc('monthly_plan').set({
      'name': 'Plan Mensual',
      'price': 30.0,
      'durationDays': 30,
      'description': 'Acceso ilimitado durante 30 días.',
      'createdAt': DateTime.now(),
    }),
    firestore.collection('memberships').doc('weekly_plan').set({
      'name': 'Plan Semanal',
      'price': 10.0,
      'durationDays': 7,
      'description': 'Acceso ilimitado durante una semana.',
      'createdAt': DateTime.now(),
    }),
    firestore.collection('memberships').doc('annual_plan').set({
      'name': 'Plan Anual',
      'price': 300.0,
      'durationDays': 365,
      'description':
          'Acceso ilimitado durante todo el año con un descuento especial.',
      'createdAt': DateTime.now(),
    }),
  ]);

  // 3. Crear usuario fake
  await Future.wait([
    firestore.collection('users').doc('6lZVfSOujcS2AvK41eMGF5h9ocz1').set({
      'user_id': '504420108',
      'name': 'Marco',
      'surname1': 'Cortés',
      'surname2': 'Castillo',
      'email': 'dueño@gmail.com',
      'phone': '555-1234',
      "roles": [
        {"id": "own", "name": "Dueño"},
      ],
      // 'membershipId': '',
      'height': 175,
      'weight': 72,
      'dateOfBirth': '1995-06-15',
      'profilePictureUrl': null,
    }),

    firestore.collection('users').doc('nqyLou9YxJP3LMgzYyzzhIUXGn32').set({
      'user_id': '504420408',
      'name': 'Ana',
      'surname1': 'Rámirez',
      'surname2': 'Gómes',
      'email': 'entrenador@gmail.com',
      'phone': '555-1234',
      "roles": [
        {"id": "coa", "name": "Entrenador"},
      ],
      // 'membershipId': '',
      'height': 186,
      'weight': 72,
      'dateOfBirth': '1995-06-15',
      'profilePictureUrl': null,
    }),

    firestore.collection('users').doc('zNR4WyEE9wTwuXIzxWarbDZtv413').set({
      'user_id': '506420108',
      'name': 'Nicole',
      'surname1': 'Vega',
      'surname2': 'Nuñez',
      'email': 'secretaria@gmail.com',
      'phone': '555-1234',
      "roles": [
        {"id": "sec", "name": "Secretario"},
      ],
      // 'membershipId': '',
      'height': 175,
      'weight': 72,
      'dateOfBirth': '1995-06-15',
      'profilePictureUrl': null,
    }),

    firestore.collection('users').doc('MT1ZtaCtYGfxWMEPYYRE8E93Lw83').set({
      'user_id': '503s420108',
      'name': 'Oscar',
      'surname1': 'Aiza',
      'surname2': 'Chavarria',
      'email': 'cliente@gmail.com',
      'phone': '555-1234',
      "roles": [
        {"id": "cli", "name": "Cliente"},
      ],
      'membershipId': 'monthly_plan',
      'height': 175,
      'weight': 72,
      'dateOfBirth': '1995-06-15',
      'profilePictureUrl': null,
    }),
  ]);

  // 4. Crear suscripción
  await firestore.collection('subscriptions').add({
    'userId': 'MT1ZtaCtYGfxWMEPYYRE8E93Lw83',
    'membershipId': 'monthly_plan',
    'startDate': DateTime.now(),
    'endDate': DateTime.now().add(Duration(days: 30)),
    'status': 'active',
    "type": 'new',
    'paymentAmount': 30.0,
    'paymentDate': DateTime.now(),
    "cancelledAt": null,
    'createdAt': DateTime.now(),
  });

  // 5. Crear asistencia
  await firestore.collection('attendances').add({
    'userId': 'MT1ZtaCtYGfxWMEPYYRE8E93Lw83',
    'date': DateTime.now(),
    'checkInTime': DateTime.now(),
    'checkOutTime': DateTime.now().add(Duration(hours: 2)),
  });

  // 6. Crear grupos musculares
  await Future.wait([
    firestore.collection('muscle_groups').doc('muscle_chest').set({
      'name': 'Chest',
      'description': 'Muscle group located in the chest area.',
    }),
    firestore.collection('muscle_groups').doc('muscle_back').set({
      'name': 'Back',
      'description': 'Muscle group located in the back area.',
    }),
    firestore.collection('muscle_groups').doc('muscle_legs').set({
      'name': 'Legs',
      "description": 'Muscle group comprising the lower limbs.',
    }),
  ]);

  // await Future.wait([
  final benchPressRef = await firestore.collection('exercises').add({
    "name": "Bench Press",
    "muscleGroupId": "muscle_chest",
    "equipment": "Barbell",
    "difficulty": "Intermediate",
    "videoUrl": "https://example.com/benchpress",
    "description":
        "Flat bench press with a barbell. Lie on a flat bench and press the barbell up and down.",
  });
  final pullUpRef = await firestore.collection('exercises').add({
    "name": "Pull-Up",
    "muscleGroupId": "muscle_back",
    "equipment": "Bodyweight",
    "difficulty": "Advanced",
    "videoUrl": "https://example.com/pullup",
    "description": "Bodyweight exercise to strengthen the back.",
  });
  final squatRef = await firestore.collection('exercises').add({
    "name": "Barbell Squat",
    "muscleGroupId": "muscle_legs",
    "equipment": "Barbell",
    "difficulty": "Intermediate",
    "videoUrl": "https://example.com/barbellsquat",
    "description":
        "Compound lower body exercise targeting quadriceps, hamstrings, and glutes.",
  });
  // ]);

  // 6. Crear workout
  final workoutRef = await firestore.collection('workouts').add({
    "title": "Full Body Routine",
    "description":
        "Basic full body strength training routine targeting chest, back, and legs.",
    "exercises": [
      {"exerciseId": benchPressRef.id, "repetitions": 12, "sets": 4},
      {"exerciseId": pullUpRef.id, "repetitions": 8, "sets": 3},
      {"exerciseId": squatRef.id, "repetitions": 10, "sets": 4},
    ],
    "createdBy":
        "nqyLou9YxJP3LMgzYyzzhIUXGn32", // opcional si quieres registrar quién creó
    "level": "Beginner", // opcional: nivel de dificultad
  });

  // 7. Asignar  workouts
  await firestore.collection('assigned_workouts').add({
    "userId": "MT1ZtaCtYGfxWMEPYYRE8E93Lw83",
    "workoutId": workoutRef.id, // referencia al workout plantilla
    "assignedAt": "2024-05-06T12:00:00Z",
    "status": "pending", // ["pending", "completed"]
    "notes": "Focus on form and technique.",
  });

  // 8. Crear progreso
  await firestore.collection('progress').add({
    "userId": "MT1ZtaCtYGfxWMEPYYRE8E93Lw83",
    "exerciseId": benchPressRef.id,
    "date": "2024-05-07T00:00:00Z",
    "setsCompleted": 4,
    "repetitionsAchieved": 12,
    "weightLiftedKg": 80.0,
    "bodyWeightKg": 75.0,
    "notes": "Felt strong. No pain in shoulders.",
  });

  // 8. Crear clase
  await firestore.collection('classes').add({
    'name': 'Spinning Class',
    'instructorId': 'nqyLou9YxJP3LMgzYyzzhIUXGn32',
    'startDateTime': DateTime.now().add(Duration(days: 3, hours: 18)),
    'endDateTime': DateTime.now().add(Duration(days: 3, hours: 19)),
    'capacity': 15,
    'attendees': ['MT1ZtaCtYGfxWMEPYYRE8E93Lw83'],
  });

  print('🎯 Datos fake creados exitosamente en Firestore.');
}
