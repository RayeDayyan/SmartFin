import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:smartfin_guide/Authentication/LoginPage.dart';
import 'package:smartfin_guide/Screens/About.dart';
import 'package:smartfin_guide/Screens/ChangePasswordScreen.dart';
import 'package:smartfin_guide/Screens/EditProfileScreen.dart';
import 'package:smartfin_guide/main.dart'; // Import your login page here

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  // Function to pick an image from gallery or take a new picture
  Future<void> _pickImage() async {
    final XFile? image = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, pickedImage);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Picture'),
                onTap: () async {
                  final pickedImage = await _picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, pickedImage);
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  void _toggleTheme() {
    final themeMode = Theme.of(context).brightness == Brightness.light
        ? ThemeMode.dark
        : ThemeMode.light;
    MyApp.of(context)?.setThemeMode(themeMode);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your login page
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Image Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: _profileImage != null
                                  ? FileImage(File(_profileImage!.path))
                                  : NetworkImage('https://img.freepik.com/free-photo/young-bearded-man-with-striped-shirt_273609-5677.jpg') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: _pickImage,
                              splashColor: Colors.white.withOpacity(0.5),
                              highlightColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // List Tiles
            ListTile(
              leading: Icon(Icons.person),
              iconColor: Colors.red,
              title: Text('Edit Profile', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  _createSlidePageRoute(EditProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              iconColor: Colors.red,
              title: Text('Notifications', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Implement notifications functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              iconColor: Colors.red,
              title: Text('Language', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Implement language selection functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Theme', style: TextStyle(fontSize: 18)),
              iconColor: Colors.red,
              onTap: _toggleTheme, // Toggle theme when tapped
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About', style: TextStyle(fontSize: 18)),
              iconColor: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  _createSlidePageRoute(AboutScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password', style: TextStyle(fontSize: 18)),
              iconColor: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  _createSlidePageRoute(ChangePasswordScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              iconColor: Colors.red,
              title: Text('Logout', style: TextStyle(fontSize: 18)),
              onTap: _logout, // Call logout functionality
            ),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _createSlidePageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
        var offsetAnimation = tween.animate(curvedAnimation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
