import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartfin_guide/Authentication/LoginPage.dart';
import 'package:smartfin_guide/Screens/AdminHomeScreen.dart';
import 'package:smartfin_guide/Screens/ClientHomeScreen.dart'; // Add Client screen import

import '../Screens/models/user.dart';

class MainAuth extends StatefulWidget {
  @override
  _MainAuthState createState() => _MainAuthState();
}

class _MainAuthState extends State<MainAuth> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Defer user status check to after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus();
    });
  }

  // Check user status
  void _checkUserStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _redirectToLogin();
      return;
    }

    final userID = currentUser.uid;
    final userData = await _fireStore.collection('users').doc(userID).get();

    if (!userData.exists) {
      _signOutAndRedirect();
      return;
    }

    final data = userData.data();
    if (data == null) {
      _signOutAndRedirect();
      return;
    }

    AppUser appUser = AppUser.fromJson(data);
    String? role = appUser.role;

    if (role == null) {
      _signOutAndRedirect();
      return;
    }

    if (role == 'admin') {
      _navigateToAdmin();
    } else if (role == 'client') {
      _navigateToClient();
    } else {
      _signOutAndRedirect();
    }
  }


  // Navigate to Admin screen
  void _navigateToAdmin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminHomeScreen()),
    );
  }

  // Navigate to Client screen
  void _navigateToClient() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ClientHomeScreen()), // Add your client screen here
    );
  }

  // Sign out and redirect to Login screen
  void _signOutAndRedirect() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    _redirectToLogin();
  }

  // Redirect to Login screen
  void _redirectToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking user status
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
