import 'package:flutter/material.dart';

class JournalWritingScreen extends StatefulWidget {
  const JournalWritingScreen({super.key});

  @override
  State<JournalWritingScreen> createState() => _JournalWritingScreenState();
}

class _JournalWritingScreenState extends State<JournalWritingScreen> {
  final TextEditingController _textController =
      TextEditingController(); //yazılan metni kaydetmek için

  final int _minCharacters = 10; //girilecek en az karakter sayısı
  final int _maxCharacters = 500; //girilecek en fazla karakter sayısı

  @override
  void dispose() {
    //memory leak ve RAM kullanımını önlemek için
    _textController.dispose();
    super.dispose();
  }

  bool get _isTextValid {
    final text = _textController.text
        .trim(); //trim:baştaki ve sondaki boşlukları temizler
    return text.isNotEmpty &&
        text.length >= _minCharacters &&
        text.length <= _maxCharacters;
  }
  /*burada boşluk bırakarak metin göndermeyi engelledik,
    boş metin gönderimini engelledik,
    karakter satırının altında ve üstünde metin göndermeyi engelledik */

  void _saveJournal() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Günlüğünüz kaydedildi!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int currentLength = _textController.text
        .trim()
        .length; //anlık karakter sayısı
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Yeni Günlük Yaz"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF47309B),
        actions: [
          IconButton(
            onPressed: _isTextValid ? _saveJournal : null,
            icon: const Icon(Icons.check, size: 28),
            color: _isTextValid
                ? const Color(0xFF47309B)
                : Colors.grey.shade400,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih Satırı
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF47309B),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "Tarih: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                  style: const TextStyle(
                    color: Color(0xFF47309B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 30, thickness: 1),

            // 10 karakterden azsa
            if (currentLength > 0 && currentLength < _minCharacters)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Kaydetmek için en az $_minCharacters girmelisiniz",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            // 500 karakter sınırı aşılmışsa
            else if (currentLength > _maxCharacters)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "En fazla $_maxCharacters girebilirsiniz",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

            // Metin giriş alanı
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.black87,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: "Duygularını Aktar...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
