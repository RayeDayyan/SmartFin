import 'package:flutter/material.dart';
import 'package:smartfin_guide/Authentication/MainAuth.dart';

class MergedScreen extends StatelessWidget {
  const MergedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: PageView(
        children: [
          ScreenContent(
            imagePath: 'assets/i1.png',
            text:
                "Navigate your financial journey with personalized guidance and expert advice from your trusted SmartFin Guide.",
            skipCallback: () {
              Navigator.push(
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
          ),
          ScreenContent(
            imagePath: 'assets/i2.png',
            text:
                "Guide your financial journey with timely updates and expert advice from your trusted SmartFin Guide.",
            skipCallback: () {
              Navigator.push(
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
          ),
          ScreenContent(
            imagePath: 'assets/i3.png',
            text:
                "Get smooth and reliable support from your trusted SmartFin Guide, ensuring informed decisions along the way.",
            skipCallback: () {
              Navigator.push(
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
            nextCallback: () {
              Navigator.push(
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
          ),
        ],
      ),
    );
  }
}

class ScreenContent extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback skipCallback;
  final VoidCallback? nextCallback;

  const ScreenContent({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.skipCallback,
    this.nextCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
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
                    color: Color.fromARGB(255, 165, 159, 173), // Grey color for text
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 36,
          left: 16,
          child: GestureDetector(
            onTap: skipCallback,
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey[800], // Dark grey text color
                fontSize: 16,
              ),
            ),
          ),
        ),
        if (nextCallback != null)
          Positioned(
            bottom: 36,
            right: 16,
            child: GestureDetector(
              onTap: nextCallback,
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.grey[800], // Dark grey text color
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
