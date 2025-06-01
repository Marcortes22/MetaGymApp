import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../models/exercise.dart';
import '../../services/exercise_service.dart';
import 'do_workout_screen.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailsScreen({
    super.key,
    required this.workout,
  });

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  final _exerciseService = ExerciseService();
  Map<String, Exercise> _exercises = {};

  String _getExerciseImage(Exercise exercise) {
    final type = exercise.name.toLowerCase();
    if (type.contains('press') || type.contains('push') || type.contains('chest')) {
      return 'assets/workouts/upper_body.jpg';
    } else if (type.contains('squat') || type.contains('leg') || type.contains('lunge')) {
      return 'assets/workouts/lower_body.jpg';
    } else if (type.contains('crunch') || type.contains('situp') || type.contains('plank')) {
      return 'assets/workouts/core.jpg';
    } else if (type.contains('run') || type.contains('sprint') || type.contains('jump')) {
      return 'assets/workouts/cardio.jpg';
    } else if (type.contains('functional') || type.contains('burpee')) {
      return 'assets/workouts/functional.jpg';
    } else if (type.contains('deadlift') || type.contains('row') || type.contains('pull')) {
      return 'assets/workouts/strength.jpg';
    }
    return 'assets/workouts/full_body.jpg';
  }

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final exerciseIds = widget.workout.exercises.map((e) => e.exerciseId).toList();
    for (final id in exerciseIds) {
      final exercise = await _exerciseService.getById(id);
      if (exercise != null) {
        setState(() {
          _exercises[id] = exercise;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.workout.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFF8C42)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.workout.exercises.length,
              itemBuilder: (context, index) {
                final workoutExercise = widget.workout.exercises[index];
                final exercise = _exercises[workoutExercise.exerciseId];

                if (exercise == null) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            _getExerciseImage(exercise),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: Icon(
                                    Icons.fitness_center,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              exercise.description,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoChip(
                                  Icons.refresh,
                                  '${workoutExercise.sets} Series',
                                ),
                                _buildInfoChip(
                                  Icons.fitness_center,
                                  '${workoutExercise.repetitions} Reps',
                                ),
                                _buildInfoChip(
                                  Icons.speed,
                                  exercise.difficulty,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _exercises.length == widget.workout.exercises.length
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoWorkoutScreen(
                            workout: widget.workout,
                            exercises: widget.workout.exercises
                                .map((e) => _exercises[e.exerciseId]!)
                                .toList(),
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C42),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Comenzar Rutina',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF8C42),
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
