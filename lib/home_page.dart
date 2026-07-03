import 'package:flutter/material.dart';

// 2. Kısayolumuzla (stless) sınıfımızı oluşturuyoruz
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tasarımımızı buraya yerleştiriyoruz
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Antigravity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Giriş Yap'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(onPressed: () {}, child: const Text('Kayıt Ol')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
