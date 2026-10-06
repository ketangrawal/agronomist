import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/diagnosis_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/diagnosis_results_screen.dart';
import 'screens/product_card_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before pumping the root widget tree
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  // Single runApp execution
  runApp(const AgronomistApp());
}

class AgronomistApp extends StatefulWidget {
  const AgronomistApp({super.key});

  @override
  State<AgronomistApp> createState() => _AgronomistAppState();
}

class _AgronomistAppState extends State<AgronomistApp> {
  Locale _locale = const Locale('en');

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? const Locale('mr') : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agronomist',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('mr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      home: HomeScreen(onToggleLocale: _toggleLocale),
      routes: {
        '/diagnosis': (context) => const DiagnosisScreen(),
        '/analysis': (context) => const AnalysisScreen(),
        '/results': (context) => const DiagnosisResultsScreen(),
        '/productCards': (context) => const ProductCardScreen(),
      },
    );
  }
}