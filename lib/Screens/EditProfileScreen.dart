import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartfin_guide/Controllers/Services/UserController.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _organizationController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isFetching = true; // For loading current user details
  final userController = UserController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserDetails(); // Load current details when the screen initializes
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.red, // Red color for app bar
      ),
      body: _isFetching
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching user details
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(), // Added bouncing physics
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(_nameController, 'Name'),
                    _buildTextField(_emailController, 'Email', isEmail: true),
                    _buildTextField(_organizationController, 'Organization'),
                    _buildTextField(_phoneController, 'Phone number', isPhone: true),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _isLoading
                ? CircularProgressIndicator() // Show loading spinner while saving
                : Container(
              height: 50,
              width: 150,
              child: ElevatedButton(
                onPressed: saveInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color for the button
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Function to load current user details from Firestore
  void _loadCurrentUserDetails() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _nameController.text = userDoc['name'] ?? '';
            _emailController.text = userDoc['email'] ?? '';
            _organizationController.text = userDoc['organization'] ?? '';
            _phoneController.text = userDoc['phone'] ?? '';
            _isFetching = false; // Data loaded, stop showing the loader
          });
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        _isFetching = false; // Stop loader even if there's an error
      });
    }
  }

  void saveInfo() async {
    Map<String, String> updatedData = {};

    if (_nameController.text.isNotEmpty) {
      updatedData['name'] = _nameController.text;
    }

    if (_emailController.text.isNotEmpty) {
      updatedData['email'] = _emailController.text;
    }

    if (_organizationController.text.isNotEmpty) {
      updatedData['organization'] = _organizationController.text;
    }

    if (_phoneController.text.isNotEmpty) {
      updatedData['phone'] = _phoneController.text;
    }

    if (updatedData.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loading spinner while saving
      });

      bool result = await userController.updateUser(updatedData);

      setState(() {
        _isLoading = false; // Hide loading spinner after saving
      });

      if (result == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Updated Data Successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Couldn\'t update data, please try again!')));
      }
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isEmail = false, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType:
        isEmail ? TextInputType.emailAddress : isPhone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Red color for the border
          ),
        ),
      ),
    );
  }
}
