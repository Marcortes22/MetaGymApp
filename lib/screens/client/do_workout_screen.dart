import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _initializeYoutubeController(widget.exercises[_currentIndex].videoUrl);
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  String? _getYoutubeId(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  void _initializeYoutubeController(String videoUrl) {
    _youtubeController?.dispose();
    final videoId = _getYoutubeId(videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          controlsVisibleAtStart: true,
        ),
      );
      setState(() {}); // Trigger rebuild to show video player
    } else {
      _youtubeController = null;
    }
  }

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
              child: exercise.videoUrl.isNotEmpty && _youtubeController != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressColors: const ProgressBarColors(
                          playedColor: Color(0xFFFF8C42),
                          handleColor: Color(0xFFFF8C42),
                        ),
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
            const Spacer(),            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentIndex--;
                          _initializeYoutubeController(widget.exercises[_currentIndex].videoUrl);
                        });
                      },
                      icon: const Icon(Icons.arrow_back_rounded, size: 24),
                      label: const Text('Anterior'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: const Color(0xFFFF8C42),
                        minimumSize: const Size(140, 56),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                if (_currentIndex < widget.exercises.length - 1)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8C42).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentIndex++;
                          _initializeYoutubeController(widget.exercises[_currentIndex].videoUrl);
                        });
                      },
                      label: const Text('Siguiente'),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 24),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8C42),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(140, 56),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                if (_currentIndex == widget.exercises.length - 1)
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8C42).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _finished = true;
                        });
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 24),
                      label: const Text('Finalizar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8C42),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(140, 56),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
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
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFF8C42), size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
