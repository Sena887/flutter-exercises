import 'routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'providers/journal_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    //ilk firebase'i başlat
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      providerAndroid: AndroidDebugProvider(),
      providerApple: AppleDebugProvider(),
    );

    final sharedPreferences = await SharedPreferences.getInstance();

    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint("Uygulama başlatılamadı: $e");
    debugPrint("Stacktrace: $stackTrace");

    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Uygulama başlatılamadı, lütfen tekrar deneyin."),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.routes,
    );
  }
}
