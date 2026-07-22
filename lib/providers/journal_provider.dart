import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import '../repositories/journal_repository.dart';
import 'package:flutter/foundation.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  //köprü/referans
  throw UnimplementedError();
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return JournalRepository(prefs);
});

class JournalHistoryNotifier extends Notifier<List<JournalEntry>> {
  late final JournalRepository _repository;

  @override
  List<JournalEntry> build() {
    _repository = ref.watch(journalRepositoryProvider);
    return _repository.loadJournals();
  }

  //Listeye yeni bir analiz sonucu ekler
  Future<bool> addEntry(JournalEntry entry) async {
    //yeni eklenen verinin eskisinin yanına eklenmesini sağlar, böylece listenin sonuna eklenir.
    final previousState = state;
    state = [entry, ...state];
    final isSaved = await _repository.saveJournals(state);

    if (!isSaved) {
      state = previousState;
      debugPrint("Günlük veritabanına kaydedilemediği için işlem geri alındı.");
    }
    return isSaved;
  }

  //tek bir günlüğk kaydını siler
  Future<bool> deleteEntry(String id) async {
    final previousState = state;
    state = state.where((item) => item.id != id).toList();

    final isSaved = await _repository.saveJournals(state);

    if (!isSaved) {
      state = previousState;
      debugPrint("Günlük veritabanından silinemediği için işlem geri alındı");
    }
    return isSaved;
  }

  //tüm günlük kayıtlarını siler
  Future<bool> clearAll() async {
    final previousState = state;
    state = [];
    final isSaved = await _repository.saveJournals(state);

    if (!isSaved) {
      state = previousState;
      debugPrint("Günlük veritabanı temizlenemediği için işlem geri alındı.");
    }
    return isSaved;
  }

  Future<bool> updateEntry(JournalEntry entry) async {
    final previousState = state;
    state = state.map((item) => item.id == entry.id ? entry : item).toList();

    final isSaved = await _repository.saveJournals(state);

    if (!isSaved) {
      state = previousState;
      debugPrint("Günlük güncellenemediği için işlem geri alındı.");
    }
    return isSaved;
  }
}

final journalProvider =
    NotifierProvider<JournalHistoryNotifier, List<JournalEntry>>(
      () => JournalHistoryNotifier(),
    );
