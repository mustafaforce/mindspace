import 'package:flutter/material.dart';

import '../controllers/mood_view_model.dart';
import '../widgets/mood_selector.dart';
import '../widgets/mood_questions_widget.dart';

class MoodLoggerScreen extends StatefulWidget {
  const MoodLoggerScreen({super.key});

  @override
  State<MoodLoggerScreen> createState() => _MoodLoggerScreenState();
}

class _MoodLoggerScreenState extends State<MoodLoggerScreen> {
  final MoodViewModel _viewModel = MoodViewModel();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.loadQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0 && _viewModel.selectedMoodScore != null) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentPage == 1) {
      _saveMoodLog();
    }
  }

  Future<void> _saveMoodLog() async {
    final label = _getMoodLabel(_viewModel.selectedMoodScore!);
    final success = await _viewModel.saveMoodLog(label);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood logged successfully!')),
      );
      Navigator.of(context).pop();
    }
  }

  String _getMoodLabel(int score) {
    const labels = ['Very Sad', 'Sad', 'Neutral', 'Happy', 'Very Happy'];
    return labels[score - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Your Mood'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentPage + 1) / 2,
                backgroundColor: Colors.grey.shade200,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildMoodSelectionPage(),
                    _buildQuestionsPage(),
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMoodSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Select the emoji that best represents your mood',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 40),
          MoodSelector(
            selectedMood: _viewModel.selectedMoodScore,
            onMoodSelected: _viewModel.setSelectedMood,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Answer these questions to get personalized insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          MoodQuestionsWidget(
            questions: _viewModel.questions,
            answers: _viewModel.answers,
            onAnswerChanged: (entry) => _viewModel.setAnswer(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentPage == 1)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Back'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: _currentPage == 0
                ? (_viewModel.selectedMoodScore != null ? _nextPage : null)
                : _nextPage,
            child: _viewModel.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_currentPage == 0 ? 'Next' : 'Save Mood'),
          ),
        ],
      ),
    );
  }
}