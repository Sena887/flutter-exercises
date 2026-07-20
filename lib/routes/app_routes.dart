import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/journal_writing_screen.dart';
import '../screens/analysis_result_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String write = '/write';
  static const String result = '/result';

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomeScreen(),
    write: (context) => const JournalWritingScreen(),
    result: (context) => const AnalysisResultScreen(),
  };
}
