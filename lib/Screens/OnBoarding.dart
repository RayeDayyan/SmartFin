import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartfin_guide/Authentication/MainAuth.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              ScreenContent(
                imagePath: 'assets/i1.png',
                text: "Navigate your financial journey with personalized guidance and expert advice from your trusted SmartFin Guide.",
              ),
              ScreenContent(
                imagePath: 'assets/i2.png',
                text: "Guide your financial journey with timely updates and expert advice from your trusted SmartFin Guide.",
              ),
              ScreenContent(
                imagePath: 'assets/i3.png',
                text: "Get smooth and reliable support from your trusted SmartFin Guide, ensuring informed decisions along the way.",
              ),
            ],
          ),
          Positioned(
            bottom: 36,
            left: 16,
            child:
                GestureDetector(
                    onTap: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('onboarding_seen', true);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 400),
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: MainAuth(),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
          Positioned(
            bottom: 36,
            right: 16,
            child: _currentIndex < 2
                ? GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('onboarding_seen', true);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 400),
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: MainAuth(),
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Finish',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ScreenContent extends StatelessWidget {
  final String imagePath;
  final String text;

  const ScreenContent({
    Key? key,
    required this.imagePath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: MediaQuery.of(context).size.width * 0.7,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 165, 159, 173),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
