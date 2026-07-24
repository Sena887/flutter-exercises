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

# 📝 Journal AI - AI-Powered Journal Application

Journal AI is a modern **Flutter** mobile application that leverages the power of Artificial Intelligence to analyze users' thoughts, daily experiences, and emotional states, providing deep psychological insights.

---

## 🚀 Features
- **AI-Powered Emotion Analysis (Gemini/Firebase Vertex AI):** Analyzes journal entries to determine the user's dominant mood (Happy, Sad, Stressed, Peaceful, Grateful, etc.).
- **Summarization & Personalized Advice:** Generates a 1-2 sentence summary of your day and provides supportive, tailored recommendations based on your current mood.
- **Offline Fallback Analyzer:** Includes an intelligent keyword-matching algorithm that functions completely offline to estimate your mood in the absence of an internet connection.
- **Turkish Character Normalization:** The offline fallback analyzer features character normalization (e.g., converting `ş` -> `s`, `ı` -> `i`) to guarantee accurate local matching.
- **Journal History & Storage:** Persists journal entries locally. Users can view historical logs, review analysis details, or delete previous entries.
- **Firebase App Check Security:** Secures all interactions between the mobile app and Firebase backends using Firebase App Check.

---

## 🛠️ Tech Stack
- **Framework:** [Flutter](https://flutter.dev) (Dart)
- **State Management:** [Riverpod](https://riverpod.dev)
- **AI/LLM:** Gemini-3.5-Flash-Lite (via Firebase Vertex AI SDK)
- **Local Storage:** SharedPreferences

---

## ⚙️ Installation & Setup

Follow these steps to run the project on your local machine:

### Prerequisites
- Flutter SDK installed on your system.
- Firebase CLI and FlutterFire CLI tools installed.

### Setup Steps

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Sena887/flutter-exercises.git
   cd journal


