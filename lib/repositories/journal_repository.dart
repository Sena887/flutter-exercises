import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  static const String _key = 'journals_key';
  final SharedPreferences _prefs;

  JournalRepository(this._prefs);

  Future<bool> saveJournals(List<JournalEntry> entries) async {
    try {
      final mapList = entries
          .map((e) => e.toMap())
          .toList(); //maplist'i iterable yaptık, ram'de yer kaplamaz

      final String jsonString = jsonEncode(mapList);

      return await _prefs.setString(_key, jsonString);
    } catch (e) {
      debugPrint("Veritabanına yazılırken hata oluştu: $e");
      return false;
    }
  }

  List<JournalEntry> loadJournals() {
    try {
      final String? jsonString = _prefs.getString(_key);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList
          .map(
            (item) =>
                JournalEntry.fromMap(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (e) {
      debugPrint("Veritabanından okurken bir hata oluştu: $e");
      return [];
    }
  }
}
