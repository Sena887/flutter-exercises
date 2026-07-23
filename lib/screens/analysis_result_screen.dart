import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/journal_provider.dart';
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../services/journal_analyzer.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';
import 'journal_writing_screen.dart';

class AnalysisResultScreen extends ConsumerStatefulWidget {
  const AnalysisResultScreen({super.key});

  @override
  ConsumerState<AnalysisResultScreen> createState() =>
      _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends ConsumerState<AnalysisResultScreen> {
  bool _isLoading = true;
  String _journalText = '';
  JournalEntry? _entry;
  JournalEntry? _editingEntry;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final inComingData = ModalRoute.of(context)?.settings.arguments;
      if (inComingData is String) {
        _journalText = inComingData;
        _startAnalysis();
        //geçmiş günlük kaydıysa doğrudan göster
      } else if (inComingData is AnalysisArguments) {
        _journalText = inComingData.text;
        _editingEntry = inComingData.editEntry;
        _startAnalysis();
      } else if (inComingData is JournalEntry) {
        _entry = inComingData;
        _isLoading = false;
      } else {
        //geçersiz veri geldiğinde yükleme ekranı kapanır
        setState(() => _isLoading = false);
      }
      _initialized = true;
    }
  }

  void _startAnalysis() {
    JournalAnalyzer.analyze(_journalText).then((resultEntry) async {
      if (mounted) {
        /*memory leak önleyicisi, kullanıcı yüklenme ekranı bitmeden geri sayfadan çıkarsa
      uygulama olmayan ekranı güncellemeye çalışır ve hata verir. Bu komutla birlikte eğer sadece ekran açıksa
      arayüzü günceller. Bu sayede programın çökmesini engeller. */
        final finalEntry = _editingEntry != null
            ? resultEntry.copyWith(
                id: _editingEntry!.id,
                date: _editingEntry!.date,
                isEdited: true,
              )
            : resultEntry;

        setState(() {
          _entry = finalEntry;
          _isLoading = false;
        });
        if (_editingEntry != null) {
          await ref.read(journalProvider.notifier).updateEntry(finalEntry);
        } else {
          //otomatik olarak geçmiş listesine ekle
          await ref.read(journalProvider.notifier).addEntry(finalEntry);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analiz Sonucu",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _AnalysisStateSwitcher(isLoading: _isLoading, entry: _entry),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget content;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          content,
        ],
      ),
    );
  }
}

//Hata Ekranı
class _ErrorView extends StatelessWidget {
  const _ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade400,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              "Analiz Başlatılamadı",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Geçersiz veya boş veri nedeniyle analiz gerçekleştirilemedi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Geri Dön"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisStateSwitcher extends StatelessWidget {
  final bool isLoading;
  final JournalEntry? entry;

  const _AnalysisStateSwitcher({required this.isLoading, required this.entry});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _LoadingWidget(key: ValueKey('loading'));
    }

    if (entry == null) {
      return const _ErrorView(key: ValueKey('error'));
    }

    return _ResultWidget(key: const ValueKey('result'), entry: entry!);
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.8),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Günlüğün Analiz Ediliyor...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Duygu durumu çözümleniyor...",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultWidget extends StatefulWidget {
  final JournalEntry entry;

  const _ResultWidget({super.key, required this.entry});

  @override
  State<_ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<_ResultWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final dateStr =
        "${widget.entry.date.day}.${widget.entry.date.month}.${widget.entry.date.year}";

    final moodColor = MoodTheme.getColor(widget.entry.mood);
    final moodIcon = MoodTheme.getIcon(widget.entry.mood);

    return RawScrollbar(
      controller: _scrollController,
      thumbColor: moodColor.withValues(alpha: 0.5),
      thickness: 5,
      radius: const Radius.circular(10),
      interactive: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        key: const ValueKey('result'),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Tarih ve Duygu Kartı
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [moodColor, moodColor.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: moodColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(moodIcon, size: 48, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Duygu Durumun",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          widget.entry.mood,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            //Özet Kartı
            _DashboardCard(
              title: "Yapay Zeka Özetin",
              icon: Icons.auto_awesome_rounded,
              iconColor: Colors.deepPurple,
              content: Text(
                widget.entry.summary,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            //3)Etiketler Kartı
            _DashboardCard(
              title: "Etiketler",
              icon: Icons.local_offer_rounded,
              iconColor: Colors.blue,
              content: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: widget.entry.tags.map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: primaryColor.withValues(alpha: 0.1),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            //4)Öneri Kartı
            _DashboardCard(
              title: "Bugün İçin Öneriler",
              icon: Icons.lightbulb_circle_rounded,
              iconColor: Colors.orange,
              content: Text(
                widget.entry.recommendation,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),

            //5)Günlük Alıntısı
            _DashboardCard(
              title: "Günlük Alıntısı",
              icon: Icons.format_quote_rounded,
              iconColor: Colors.grey,
              content: Container(
                padding: const EdgeInsets.only(left: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: primaryColor.withValues(alpha: 0.3),
                      width: 4,
                    ),
                  ),
                ),
                child: Text(
                  '"${widget.entry.content}"',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            //6)Aksiyon Butonları
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(AppRoutes.welcome),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded),
                  SizedBox(width: 8),
                  Text(
                    "Ana Sayfaya Dön",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_note_rounded),
                  SizedBox(width: 8),
                  Text(
                    "Yeni Günlük Yaz",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
