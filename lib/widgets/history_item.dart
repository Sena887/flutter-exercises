import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import '../theme/app_theme.dart';
import '../providers/journal_provider.dart';
import '../routes/app_routes.dart';
import 'success_dialog.dart';

class HistoryItem extends ConsumerWidget {
  final JournalEntry entry;

  const HistoryItem({super.key, required this.entry});

  String _pad(int n) => n.toString().padLeft(2, '0'); //padding

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Pazartesi';
      case DateTime.tuesday:
        return 'Salı';
      case DateTime.wednesday:
        return 'Çarşamba';
      case DateTime.thursday:
        return 'Perşembe';
      case DateTime.friday:
        return 'Cuma';
      case DateTime.saturday:
        return 'Cumartesi';
      case DateTime.sunday:
        return 'Pazar';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = entry.date;

    final dayName = _getDayName(date.weekday);
    final formattedDateTime =
        "${_pad(date.day)}.${_pad(date.month)}.${date.year} $dayName - ${_pad(date.hour)}:${_pad(date.minute)}";

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
            contentPadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 26,
              bottom: 8,
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
              Navigator.pushNamed(context, AppRoutes.result, arguments: entry);
            },
          ),
          Positioned(
            top: 4,
            left: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.grey,
                    size: 18,
                  ),
                  padding: EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.write,
                        arguments: entry,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8),
                          Text("Düzenle"),
                        ],
                      ),
                    ),
                  ],
                ),
                if (entry.isEdited) ...[
                  //(...) spread operatörü
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.access_time_rounded,
                    color: Colors.orangeAccent,
                    size: 14,
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 4,
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
                  builder: (context) => _DeleteConfirmDialog(entryId: entry.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Tekli günlük silme
class _DeleteConfirmDialog extends ConsumerWidget {
  final String entryId;

  const _DeleteConfirmDialog({required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
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
            await ref.read(journalProvider.notifier).deleteEntry(entryId);
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (context) => const SuccessDialog(
                  message: "Günlük kaydı başarıyla silindi.",
                ),
              );
            }
          },
          child: const Text("Sil", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
