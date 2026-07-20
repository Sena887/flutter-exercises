import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import '../theme/app_theme.dart';
import '../providers/journal_provider.dart';
import '../routes/app_routes.dart';

class HistoryItem extends ConsumerWidget {
  final JournalEntry entry;

  const HistoryItem({super.key, required this.entry});

  String _pad(int n) => n.toString().padLeft(2, '0'); //padding

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
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
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.result, arguments: entry);
            },
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
                size: 18,
              ),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Günlüğü Sil"),
                    content: const Text(
                      "Bu günlük kaydını silmek istediğinize emin misiniz?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Vazgeç"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          await ref
                              .read(journalProvider.notifier)
                              .deleteEntry(entry.id);

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Başarılı"),
                                content: const Text(
                                  "Günlük kaydı başarıyla silindi.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Tamam"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Sil",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
