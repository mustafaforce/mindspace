import 'dart:async';
import 'package:flutter/material.dart';
import '../controllers/exercise_view_model.dart';
import '../widgets/breathing_animation.dart';
import '../../../../core/services/navigation_service.dart';

class ExercisePlayerScreen extends StatefulWidget {
  final String exerciseId;

  const ExercisePlayerScreen({super.key, required this.exerciseId});

  @override
  State<ExercisePlayerScreen> createState() => _ExercisePlayerScreenState();
}

class _ExercisePlayerScreenState extends State<ExercisePlayerScreen> {
  final ExerciseViewModel _viewModel = ExerciseViewModel();
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.loadExerciseById(widget.exerciseId);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _startTimer();
    } else {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _nextStep();
      }
    });
  }

  void _nextStep() {
    final exercise = _viewModel.selectedExercise;
    if (exercise == null) return;

    if (_currentStepIndex < exercise.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _remainingSeconds = exercise.steps[_currentStepIndex].durationSeconds;
      });
    } else {
      _completeExercise();
    }
  }

  void _completeExercise() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    _showMoodAfterDialog();
  }

  void _showMoodAfterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('How do you feel now?'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final score = index + 1;
            return GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                _viewModel.completeExercise(score, null);
                NavigationService.instance.pop();
              },
              child: Text(
                _getMoodEmoji(score),
                style: const TextStyle(fontSize: 32),
              ),
            );
          }),
        ),
      ),
    );
  }

  String _getMoodEmoji(int score) {
    const emojis = ['😔', '😐', '🙂', '😊', '😄'];
    return emojis[score - 1];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final exercise = _viewModel.selectedExercise;
        if (_viewModel.isLoading || exercise == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Exercise')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final currentStep = exercise.steps[_currentStepIndex];
        final isBreathing = exercise.category == 'breathing';

        return Scaffold(
          appBar: AppBar(
            title: Text(exercise.title),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _timer?.cancel();
                _viewModel.clearSelection();
                NavigationService.instance.pop();
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isBreathing)
                          BreathingAnimation(
                            isActive: _isPlaying,
                            durationSeconds: currentStep.durationSeconds,
                          ),
                        if (!isBreathing)
                          Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                ),
                                child: Center(
                                  child: Text(
                                    exercise.categoryIcon,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                currentStep.instruction,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer_outlined, size: 20, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(_remainingSeconds),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Step ${_currentStepIndex + 1} of ${exercise.steps.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      if (_currentStepIndex > 0)
                        TextButton(
                          onPressed: () {
                            _timer?.cancel();
                            setState(() {
                              _currentStepIndex--;
                              _remainingSeconds = exercise.steps[_currentStepIndex].durationSeconds;
                              _isPlaying = false;
                            });
                          },
                          child: const Text('Previous'),
                        ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _togglePlayPause,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(_isPlaying ? 'Pause' : 'Start'),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _completeExercise,
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}