import 'package:flutter/foundation.dart';

import '../../data/datasources/mood_remote_datasource.dart';
import '../../data/repositories/mood_repository_impl.dart';
import '../../domain/entities/mood_log.dart';
import '../../domain/entities/mood_question.dart';
import '../../domain/entities/mood_question_response.dart';
import '../../domain/usecases/log_mood_usecase.dart';
import '../../domain/usecases/get_mood_history_usecase.dart';
import '../../domain/usecases/get_mood_questions_usecase.dart';

class MoodViewModel extends ChangeNotifier {
  late final MoodRepositoryImpl _repository;
  late final LogMoodUseCase _logMoodUseCase;
  late final GetMoodHistoryUseCase _getMoodHistoryUseCase;
  late final GetMoodQuestionsUseCase _getMoodQuestionsUseCase;

  MoodViewModel() {
    final dataSource = MoodRemoteDataSource();
    _repository = MoodRepositoryImpl(dataSource);
    _logMoodUseCase = LogMoodUseCase(_repository);
    _getMoodHistoryUseCase = GetMoodHistoryUseCase(_repository);
    _getMoodQuestionsUseCase = GetMoodQuestionsUseCase(_repository);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<MoodLog> _moodHistory = [];
  List<MoodLog> get moodHistory => _moodHistory;

  List<MoodQuestion> _questions = [];
  List<MoodQuestion> get questions => _questions;

  Map<String, int> _answers = {};
  Map<String, int> get answers => _answers;

  int? _selectedMoodScore;
  int? get selectedMoodScore => _selectedMoodScore;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  void setSelectedMood(int score) {
    _selectedMoodScore = score;
    notifyListeners();
  }

  void setAnswer(String questionId, int value) {
    _answers[questionId] = value;
    notifyListeners();
  }

  Future<void> loadQuestions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _questions = await _getMoodQuestionsUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoodHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _moodHistory = await _getMoodHistoryUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveMoodLog(String moodLabel) async {
    if (_selectedMoodScore == null) return false;

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final responses = _answers.entries.map((entry) {
        return MoodQuestionResponse(
          id: '',
          userId: '',
          moodLogId: '',
          questionId: entry.key,
          responseValue: entry.value,
          createdAt: DateTime.now(),
        );
      }).toList();

      await _logMoodUseCase(
        moodScore: _selectedMoodScore!,
        moodLabel: moodLabel,
        responses: responses,
      );

      _selectedMoodScore = null;
      _answers = {};
      await loadMoodHistory();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void reset() {
    _selectedMoodScore = null;
    _answers = {};
    _error = null;
    notifyListeners();
  }
}