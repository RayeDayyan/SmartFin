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
  final _departmentController = TextEditingController(); // New field
  final _positionController = TextEditingController(); // New field
  final _employeeIdController = TextEditingController(); // New field
  bool check = false;
  final userController = UserController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.red, // Red color for app bar
      ),
      body: Padding(
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
                    _buildTextField(_emailController, 'Email'),
                    _buildTextField(_organizationController, 'Organization'),
                    _buildTextField(_phoneController, 'Phone number'),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  saveInfo();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red color for the button
                ),
                child: Text('Save', style: TextStyle(color: Colors.white),) ,
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveInfo() async{
    Map<String,String> updatedData = {};

    if(_nameController.text.isNotEmpty){
      check = true;
      updatedData['name']=_nameController.text.toString();
    }

    if(_emailController.text.isNotEmpty){
      check = true;
      updatedData['email']=_emailController.text.toString();
    }

    if(_organizationController.text.isNotEmpty){
      check = true;
      updatedData['organization']=_organizationController.text.toString();
    }

    if(_phoneController.text.isNotEmpty){
      check = true;
      updatedData['phone']=_phoneController.text.toString();
    }

    if(check==true){

      bool result = await userController.updateUser(updatedData);
        if(result==true){

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Updated Data Successfully')));
          Navigator.pop(context);
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Couldnt update data, please try again!')));
        }
    }else{
      Navigator.pop(context);
    }



  }

  // Helper function to retrieve admin password securely
  Future<String> _getAdminPassword(String adminUid) async {
    final _fireStore = FirebaseFirestore.instance;
    // This should be retrieved from secure storage or Firestore (if stored securely).
    final adminData = await _fireStore.collection('users').doc(adminUid).get();
    return adminData['password']; // You should have stored the password securely in Firestore or Secure Storage
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
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
