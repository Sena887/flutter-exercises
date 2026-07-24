import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF47309B);
  static const Color backgroundColor = Color(0xFFF8F9FA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
      ),
    );
  }
}

class MoodTheme {
  static Color getColor(String mood) {
    switch (mood) {
      case 'Mutlu':
        return const Color(0xFFFFB300);
      case 'Üzgün':
        return const Color(0xFF1E88E5);
      case 'Stresli':
        return const Color(0xFF7E57C2);
      case 'Öfkeli':
        return const Color(0xFFE53935);
      case 'Endişeli':
        return const Color(0xFF00897B);
      case 'Heyecanlı':
        return const Color(0xFFFF7043);
      case 'Huzurlu':
        return const Color(0xFF9CCC65);
      case 'Yalnız':
        return const Color(0xFF90A4AE);
      case 'Umutlu':
        return const Color(0xFF26C6DA);
      case 'Şaşkın':
        return const Color(0xFFFFCA28);
      case 'Minnettar':
        return const Color(0xFFEC407A);
      default:
        return const Color(0xFF43A047);
    }
  }

  static IconData getIcon(String mood) {
    switch (mood) {
      case 'Mutlu':
        return Icons.sentiment_very_satisfied_rounded;
      case 'Üzgün':
        return Icons.sentiment_dissatisfied_rounded;
      case 'Stresli':
        return Icons.bolt_rounded;
      case 'Öfkeli':
        return Icons.sentiment_very_dissatisfied_rounded;
      case 'Endişeli':
        return Icons.track_changes_rounded;
      case 'Heyecanlı':
        return Icons.celebration_rounded;
      case 'Huzurlu':
        return Icons.wb_sunny_rounded;
      case 'Yalnız':
        return Icons.cloud_rounded;
      case 'Umutlu':
        return Icons.explore_rounded;
      case 'Şaşkın':
        return Icons.help_outline_rounded;
      case 'Minnettar':
        return Icons.favorite_rounded;
      default:
        return Icons.spa_rounded;
    }
  }
}
