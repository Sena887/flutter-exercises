import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/journal_provider.dart';
import '../widgets/history_item.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(journalProvider);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Günlük Geçmişi",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryColor,
        actions: [
          if (entries.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: Colors.redAccent,
              ),
              tooltip: "Tüm Geçmişi Temizle",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Tüm Geçmişi Sil"),
                    content: const Text(
                      "Tüm geçmişi silmek istediğinize emin misiniz? Bu işlem geri alınamaz!",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Vazgeç"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await ref.read(journalProvider.notifier).clearAll();
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Başarılı"),
                                content: const Text(
                                  "Tüm günlük geçmişi başarıyla temizlendi.",
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
                          "Tümünü Sil",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: entries.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Henüz kaydedilmiş günlük bulunmuyor.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: entries.length,
              separatorBuilder: (context, index) {
                final currentEntry = entries[index];
                final nextEntry = entries[index + 1];

                final currentDate = currentEntry.date;
                final nextDate = nextEntry.date;

                final isDifferentDay =
                    currentDate.day != nextDate.day ||
                    currentDate.month != nextDate.month ||
                    currentDate.year != nextDate.year;

                if (isDifferentDay) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child: Divider(
                      color: primaryColor.withValues(alpha: 0.15),
                      thickness: 1.5,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              itemBuilder: (context, index) {
                return HistoryItem(entry: entries[index]);
              },
            ),
    );
  }
}
