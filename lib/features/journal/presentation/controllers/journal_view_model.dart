import 'package:flutter/foundation.dart';

import '../../data/datasources/journal_remote_datasource.dart';
import '../../data/repositories/journal_repository_impl.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/usecases/get_journal_entries_usecase.dart';
import '../../domain/usecases/create_journal_entry_usecase.dart';

class JournalViewModel extends ChangeNotifier {
  late final JournalRepositoryImpl _repository;
  late final GetJournalEntriesUseCase _getEntriesUseCase;
  late final CreateJournalEntryUseCase _createEntryUseCase;

  JournalViewModel() {
    final dataSource = JournalRemoteDataSource();
    _repository = JournalRepositoryImpl(dataSource);
    _getEntriesUseCase = GetJournalEntriesUseCase(_repository);
    _createEntryUseCase = CreateJournalEntryUseCase(_repository);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<JournalEntry> _entries = [];
  List<JournalEntry> get entries => _entries;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Future<void> loadEntries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _entries = await _getEntriesUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEntry({
    String? moodLogId,
    required String entryText,
    required String entryType,
    String? promptQuestion,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final entry = await _createEntryUseCase(
        moodLogId: moodLogId,
        entryText: entryText,
        entryType: entryType,
        promptQuestion: promptQuestion,
      );
      _entries.insert(0, entry);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateEntry({
    required String id,
    required String entryText,
  }) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _repository.updateJournalEntry(
        id: id,
        entryText: entryText,
      );
      final index = _entries.indexWhere((e) => e.id == id);
      if (index != -1) {
        _entries[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEntry(String id) async {
    _error = null;

    try {
      await _repository.deleteJournalEntry(id);
      _entries.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }
}