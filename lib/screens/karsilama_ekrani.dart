import 'package:flutter/material.dart';
import 'gunluk_yazma_ekrani.dart';

class KarsilamaEkrani extends StatelessWidget {
  const KarsilamaEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        toolbarHeight: 90,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF47309B), width: 2),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "JOURNAL",
            style: TextStyle(
              color: Color(0xFF47309B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 71, 48, 155),
              ),
              child: const Text(
                "Günlük Geçmişi",
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(214, 255, 255, 255),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Geçmiş Günlük Kayıtları(Yakında)"),
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bugün nasıl hissediyorsun?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: const Color(0xFF47309B),
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    offset: const Offset(2, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GunlukYazmaEkrani(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF47309B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: const Text(
                "Yazmaya Başla",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
