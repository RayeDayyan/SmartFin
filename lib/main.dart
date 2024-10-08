import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartfin_guide/Screens/OnBoarding.dart';
import 'package:smartfin_guide/Screens/splashScreen.dart';
import 'package:smartfin_guide/Authentication/MainAuth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _onboardingSeen = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingSeen();
  }

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  Future<void> _checkOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('onboarding_seen') ?? false;
    setState(() {
      _onboardingSeen = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
        ),
      ),
      home: _onboardingSeen ? SplashScreen() : OnboardingScreen(),
    );
  }
}
