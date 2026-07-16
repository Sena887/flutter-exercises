import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';

class JournalHistoryNotifier extends Notifier<List<JournalEntry>> {
  @override
  List<JournalEntry> build() {
    return [];
  }

  //Listeye yeni bir analiz sonucu ekler
  void addEntry(JournalEntry entry) {
    //yeni eklenen verinin eskisinin yanına eklenmesini sağlar, böylece listenin sonuna eklenir.
    state = [...state, entry];
  }
}

final journalProvider =
    NotifierProvider<JournalHistoryNotifier, List<JournalEntry>>(
      () => JournalHistoryNotifier(),
    );
