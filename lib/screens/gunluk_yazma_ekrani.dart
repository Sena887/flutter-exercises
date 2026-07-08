import 'package:flutter/material.dart';

class GunlukYazmaEkrani extends StatefulWidget {
  const GunlukYazmaEkrani({super.key});

  @override
  State<GunlukYazmaEkrani> createState() => _GunlukYazmaEkraniState();
}

class _GunlukYazmaEkraniState extends State<GunlukYazmaEkrani> {
  final TextEditingController _yaziController =
      TextEditingController(); //yazılan metni kaydetmek için

  final int _enAzKarakter = 10; //girilecek en az karakter sayısı
  final int _enFazlaKarakter = 500; //girilecek en fazla karakter sayısı

  @override
  void dispose() {
    //memory leak ve RAM kullanımını önlemek için
    _yaziController.dispose();
    super.dispose();
  }

  bool get _yaziGecerliMi {
    final metin = _yaziController.text
        .trim(); //trim:baştaki ve sondaki boşlukları temizler
    return metin.isNotEmpty &&
        metin.length >= _enAzKarakter &&
        metin.length <= _enFazlaKarakter;
  }
  /*burada boşluk bırakarak metin göndermeyi engelledik,
    boş metin gönderimini engelledik,
    karakter satırının altında ve üstünde metin göndermeyi engelledik */

  void _kaydet() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Günlüğünüz kaydedildi!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int anlikKarakterSayisi = _yaziController.text.trim().length;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Yeni Günlük Yaz"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF47309B),
        actions: [
          IconButton(
            onPressed: _yaziGecerliMi ? _kaydet : null,
            icon: const Icon(Icons.check, size: 28),
            color: _yaziGecerliMi
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
            if (anlikKarakterSayisi > 0 && anlikKarakterSayisi < _enAzKarakter)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "Kaydetmek için en az $_enAzKarakter girmelisiniz",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            // 500 karakter sınırı aşılmışsa
            else if (anlikKarakterSayisi > _enFazlaKarakter)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "En fazla $_enFazlaKarakter girebilirsiniz",
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
                controller: _yaziController,
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
