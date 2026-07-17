class JournalEntry {
  final String id;
  final String content;
  final DateTime date;
  final String mood;
  final String summary;
  final String recommendation;
  final List<String> tags;

  const JournalEntry({
    required this.id,
    required this.content,
    required this.date,
    required this.mood,
    required this.summary,
    required this.recommendation,
    required this.tags,
    //sözlük - map
  });
  //JSON'a çevirmek için nesneyi Map yapısına dönüştürdük
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'mood': mood,
      'summary': summary,
      'recommendation': recommendation,
      'tags': tags,
    };
  }

  //Map'ten JournalEntry - Dart nesnesi oluşturduk
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String? ?? DateTime.now().toIso8601String(),
      content: map['content'] as String? ?? '',
      date: map['date'] != null
          ? DateTime.parse(map['date'] as String)
          : DateTime.now(),
      mood: map['mood'] as String? ?? 'Dengeli',
      summary: map['summary'] as String? ?? '',
      recommendation: map['recommendation'] as String? ?? '',
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}
