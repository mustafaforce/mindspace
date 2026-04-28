import 'package:flutter/foundation.dart';
import '../../domain/entities/guided_exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../../data/datasources/exercise_remote_datasource.dart';
import '../../data/repositories/exercise_repository_impl.dart';
import '../../domain/usecases/get_exercises_usecase.dart';
import '../../domain/usecases/start_exercise_session_usecase.dart';

class ExerciseViewModel extends ChangeNotifier {
  late final ExerciseRemoteDatasource _dataSource;
  late final ExerciseRepositoryImpl _repository;
  late final GetExercisesUseCase _getExercises;
  late final GetExerciseByIdUseCase _getExerciseById;
  late final StartExerciseSessionUseCase _startSession;
  late final CompleteExerciseSessionUseCase _completeSession;

  ExerciseViewModel() {
    _dataSource = ExerciseRemoteDatasource();
    _repository = ExerciseRepositoryImpl(_dataSource);
    _getExercises = GetExercisesUseCase(_repository);
    _getExerciseById = GetExerciseByIdUseCase(_repository);
    _startSession = StartExerciseSessionUseCase(_repository);
    _completeSession = CompleteExerciseSessionUseCase(_repository);
  }

  List<GuidedExercise> _exercises = [];
  List<GuidedExercise> get exercises => _exercises;

  GuidedExercise? _selectedExercise;
  GuidedExercise? get selectedExercise => _selectedExercise;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _activeSessionId;
  String? get activeSessionId => _activeSessionId;

  Future<void> loadExercises() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _exercises = await _getExercises();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadExerciseById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedExercise = await _getExerciseById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectExercise(GuidedExercise exercise) {
    _selectedExercise = exercise;
    notifyListeners();
  }

  Future<void> startExercise(int? moodBefore) async {
    if (_selectedExercise == null) return;
    try {
      _activeSessionId = await _startSession(_selectedExercise!.id, moodBefore);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeExercise(int? moodAfter, String? notes) async {
    if (_activeSessionId == null) return;
    try {
      await _completeSession(_activeSessionId!, moodAfter, notes);
      _activeSessionId = null;
      _selectedExercise = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedExercise = null;
    _activeSessionId = null;
    notifyListeners();
  }
}