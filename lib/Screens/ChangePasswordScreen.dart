import 'package:flutter/material.dart';
import 'package:smartfin_guide/Controllers/Services/UserController.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final userController = UserController();

  void changePass()async{
    if(_newPasswordController.text != _confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match!')));
    }else{
      bool result = await userController.changePass(_newPasswordController.text.toString(),_oldPasswordController.text.toString());

      if(result==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed Successfully')));
        Navigator.pop(context);

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error Occurred')));
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
            _buildTextField(_oldPasswordController, 'Old Password'),
            SizedBox(height: 16),
            _buildTextField(_newPasswordController, 'New Password'),
            SizedBox(height: 16),
            _buildTextField(_confirmPasswordController, 'Confirm New Password'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: (){
                changePass();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set the background color to red
                padding: EdgeInsets.symmetric(vertical: 16.0), // Increased button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Less circular corners
                ),
              ),
              child: Text('Change Password', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        hintText: 'Enter $label',
        hintStyle: TextStyle(color: Colors.grey), // Grey hint text
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0), // Red border when focused
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0), // Grey border when not focused
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      obscureText: true,
    );
  }
}
