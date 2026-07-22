import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String write = '/write';
  static const String result = '/result';
  static const String history = '/history';

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomeScreen(),
    write: (context) => const JournalWritingScreen(),
    result: (context) => const AnalysisResultScreen(),
    history: (context) => const HistoryScreen(),
  };
}
