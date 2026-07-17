import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/app_theme.dart';

class HistoryItem extends StatelessWidget {
  final JournalEntry entry;

  const HistoryItem({super.key, required this.entry});

  String _pad(int n) => n.toString().padLeft(2, '0'); //padding

  @override
  Widget build(BuildContext context) {
    final date = entry.date;

    final formattedDateTime =
        "${_pad(date.day)}.${_pad(date.month)}.${date.year} - ${_pad(date.hour)}:${_pad(date.minute)}";

    final moodColor = MoodTheme.getColor(entry.mood);
    final moodIcon = MoodTheme.getIcon(entry.mood);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: moodColor.withValues(alpha: 0.15),
          child: Icon(moodIcon, color: moodColor, size: 24),
        ),
        title: Text(
          formattedDateTime,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            entry.mood,
            style: TextStyle(
              color: moodColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/result', arguments: entry);
        },
      ),
    );
  }
}
