# journal

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 📝 Journal AI - Yapay Zeka Destekli Günlük Uygulaması

Journal AI, kullanıcıların günlük yaşantılarını ve duygularını kaleme alırken yapay zekanın gücünden faydalanarak derinlemesine analizler sunan, modern bir **Flutter** mobil uygulamasıdır.

---

## 🚀 Özellikler
- **Yapay Zeka Destekli Analiz (Gemini/Firebase Vertex AI):** Günlük yazılarınızı analiz ederek o günkü baskın duygunuzu (Mutlu, Üzgün, Stresli, Huzurlu, Minnettar vb.) tespit eder.
- **Destekleyici Özetler ve Tavsiyeler:** Yapay zeka, o günkü ruh halinize göre size destekleyici, motive edici tavsiyeler ve 1-2 cümlelik özetler hazırlar.
- **Yerel (Çevrimdışı) Analizör (Fallback):** İnternet bağlantınız olmasa dahi, akıllı anahtar kelime eşleştirme algoritması sayesinde duygu durumunuzu çevrimdışı olarak tahmin eder.
- **Türkçe Karakter Duyarlılığı:** Çevrimdışı analizör, Türkçe karakter yumuşatma (normalizasyon) mantığıyla çalışır (`ş` -> `s`, `ı` -> `i` vb. dönüştürerek hatasız eşleştirme yapar).
- **Günlük Geçmişi ve Kayıt:** Yazdığınız tüm günlükler yerel veri depolama (SharedPreferences) ile saklanır.
- **Firebase App Check Güvenliği:** Firebase servisleri ile olan tüm iletişim App Check güvenlik katmanı ile korunur.

---

## 🛠️ Kullanılan Teknolojiler
- **Framework:** [Flutter](https://flutter.dev) (Dart)
- **State Management:** [Riverpod](https://riverpod.dev)
- **AI/LLM:** Gemini-3.5-Flash-Lite (Firebase Vertex AI SDK aracılığıyla)
- **Local Storage:** SharedPreferences

---

## ⚙️ Kurulum ve Çalıştırma

Bu projeyi kendi bilgisayarınızda çalıştırmak için aşağıdaki adımları izleyin:

1. **Projeyi Klonlayın:**
   ```bash
   git clone https://github.com/Sena887/flutter-exercises.git
   cd journal

