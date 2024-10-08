import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartfin_guide/Authentication/LoginPage.dart';
import 'package:smartfin_guide/Screens/AdminHomeScreen.dart';

class MainAuth extends StatefulWidget {
  @override
  _MainAuthState createState() => _MainAuthState();
}

class _MainAuthState extends State<MainAuth> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? LoginScreen() : AdminHomeScreen(user: _user!);
  }
}
