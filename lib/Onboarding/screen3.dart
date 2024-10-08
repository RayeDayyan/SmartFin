import 'package:flutter/material.dart';
import 'package:smartfin_guide/Authentication/MainAuth.dart';

class Screen3 extends StatelessWidget {
  const Screen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/i3.png',
                  height: MediaQuery.of(context).size.width * 0.7,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Get smooth and reliable support from your trusted SmartFin Guide, ensuring informed decisions along the way.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 165, 159, 173), // Red color for text
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
              onTap: () {
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
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.grey[800], // Dark grey text color
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 36,
            right: 16,
            child: GestureDetector(
              onTap: () {
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
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.grey[800], // Red color for text
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
