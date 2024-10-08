import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _departmentController = TextEditingController(); // New field
  final _positionController = TextEditingController(); // New field
  final _employeeIdController = TextEditingController(); // New field

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
                    _buildTextField(_phoneController, 'Phone Number'),
                    _buildTextField(_addressController, 'Address'),
                    _buildTextField(_departmentController, 'Department'), // New field
                    _buildTextField(_positionController, 'Position'), // New field
                    _buildTextField(_employeeIdController, 'Employee ID'), // New field
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save profile information
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red color for the button
              ),
              child: Text('Save', style: TextStyle(color: Colors.white),) ,
            ),
          ],
        ),
      ),
    );
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
