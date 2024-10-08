import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package to your pubspec.yaml for URL launching

class AboutScreen extends StatelessWidget {
  // Function to launch a URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: Text(
                'About This App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Secret Credit Hacks LLC’s app! Our app is designed to help you manage your credit and financial information with ease. Whether you are looking to monitor your credit score, track your expenses, or get insights into your financial health, our app offers a comprehensive suite of tools to meet your needs.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Features:',
              style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Secure Data Protection: We use advanced technology to ensure your data is protected and privacy is maintained.\n\n'
              'User-Friendly Interface: Navigate through our app with ease thanks to a sleek and intuitive design.'
              'Timely Updates: Receive timely updates regarding your case status',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Developed by Muhammad Faraz',
              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _launchURL('https://www.linkedin.com/in/muhammad-faraz-a11b10218/'),
                  child: Text(
                    'LinkedIn Profile',
                    style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _launchURL('https://github.com/farazmb'),
                  child: Text(
                    'GitHub Profile',
                    style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Secret Credit Hacks LLC',
              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We are a virtual company based in California, USA. Our mission is to provide innovative solutions for credit management and financial well-being. We are committed to offering high-quality services and support to help our users achieve their financial goals.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'For more details, visit our website or contact support. We value your feedback and are always here to assist you with any questions or concerns you may have.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle button press if needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set the background color to red
                padding: EdgeInsets.symmetric(vertical: 16.0), // Increased button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Less circular corners
                ),
              ),
              child: Text('Contact Support', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
