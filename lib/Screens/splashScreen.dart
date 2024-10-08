// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smartfin_guide/Screens/OnBoarding.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }
  _navigatetohome()async{
    await Future.delayed(Duration(milliseconds: 2000), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OnboardingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset("assets/logo.png", height: MediaQuery.of(context).size.width * 0.5,)
          ),
      ),
    );
  }
}