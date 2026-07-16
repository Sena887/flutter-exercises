class JournalEntry {
  final String id;
  final String content;
  final DateTime date;
  final String mood;
  final String summary;
  final String recommendation;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.content,
    required this.date,
    required this.mood,
    required this.summary,
    required this.recommendation,
    required this.tags,
    //sözlük - map
  });
}
