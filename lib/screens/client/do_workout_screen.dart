import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../models/exercise.dart';

class DoWorkoutScreen extends StatefulWidget {
  final Workout workout;
  final List<Exercise> exercises;

  const DoWorkoutScreen({
    super.key,
    required this.workout,
    required this.exercises,
  });

  @override
  State<DoWorkoutScreen> createState() => _DoWorkoutScreenState();
}

class _DoWorkoutScreenState extends State<DoWorkoutScreen> {
  int _currentIndex = 0;
  bool _finished = false;

  @override
  Widget build(BuildContext context) {
    if (_finished) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFFFF8C42), size: 80),
              const SizedBox(height: 24),
              const Text(
                '¡Felicidades!\nTerminaste la rutina',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C42),
                  minimumSize: const Size(180, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Volver', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      );
    }

    final exercise = widget.exercises[_currentIndex];
    final workoutExercise = widget.workout.exercises.firstWhere((e) => e.exerciseId == exercise.id);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ejercicio ${_currentIndex + 1} de ${widget.exercises.length}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFF8C42)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: exercise.videoUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        exercise.videoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.fitness_center, color: Colors.white, size: 48),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Icon(Icons.fitness_center, color: Colors.white, size: 48),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              exercise.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              exercise.description,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoChip(Icons.refresh, '${workoutExercise.sets} Series'),
                _buildInfoChip(Icons.fitness_center, '${workoutExercise.repetitions} Reps'),
                _buildInfoChip(Icons.speed, exercise.difficulty),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex--;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      minimumSize: const Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Anterior', style: TextStyle(fontSize: 16)),
                  ),
                if (_currentIndex < widget.exercises.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex++;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C42),
                      minimumSize: const Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Siguiente', style: TextStyle(fontSize: 16)),
                  ),
                if (_currentIndex == widget.exercises.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _finished = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C42),
                      minimumSize: const Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Finalizar', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          ],
        ),
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
          Icon(icon, color: const Color(0xFFFF8C42), size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
