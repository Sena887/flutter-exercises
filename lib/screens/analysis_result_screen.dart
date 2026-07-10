import 'package:flutter/material.dart';

class AnalysisResultScreen extends StatelessWidget {
  // Günlük yazma ekranından gönderilen metin buradan alınır
  const AnalysisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journalText =
        ModalRoute.of(context)?.settings.arguments as String? ?? "";

    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text("Analiz Sonucu")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.analytics, size: 64, color: primaryColor),
              const SizedBox(height: 20),
              Text(
                "Yazılan Günlük İçeriği:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              // Kullanıcının yazdığı metni gönderdiği yer
              Text(
                journalText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
