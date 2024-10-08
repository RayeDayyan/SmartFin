import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClientScreen extends StatefulWidget {
  @override
  _AddClientScreenState createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  FilePickerResult? _selectedFile;
  String? _selectedFileName;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ssnController = TextEditingController();
  @override
  void dispose() {
    _dobController.dispose();
    _ssnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Add Client'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Full Legal Name'),
              _buildOptionalTextField('Address'),
              _buildTextField('Email'),
              _buildDateOfBirthField(),
              _buildOptionalSSNField(),
              _buildFilePickerField(),
              if (_selectedFileName != null) _buildFileThumbnail(),
              SizedBox(height: 20),
              _buildAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(Icons.text_fields),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _formKey.currentState?.validate();
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) {
          _formData[label] = value!;
        },
      ),
    );
  }

  Widget _buildOptionalTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(Icons.text_fields),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _formKey.currentState?.validate();
        },
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            _formData[label] = value;
          }
        },
      ),
    );
  }

  Widget _buildDateOfBirthField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _dobController,
        decoration: InputDecoration(
          hintText: 'Date of Birth',
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              _dobController.text = DateFormat('MM-dd-yyyy').format(pickedDate);
            });
          }
        },
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            _formData['Date of Birth'] = value;
          }
        },
      ),
    );
  }

  Widget _buildOptionalSSNField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _ssnController,
        decoration: InputDecoration(
          hintText: 'SSN',
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: TextInputType.number,
        maxLength: 11,
        onChanged: (value) {
          _formKey.currentState?.validate();
          setState(() {
            _ssnController.value = TextEditingValue(
              text: _formatSSN(value),
              selection: TextSelection.collapsed(offset: _formatSSN(value).length),
            );
          });
        },
        onSaved: (value) {
          if (value != null && value.isNotEmpty) {
            _formData['SSN'] = value;
          }
        },
      ),
    );
  }

  String _formatSSN(String value) {
    value = value.replaceAll(RegExp(r'[^\d]'), '');
    if (value.length > 3 && value.length <= 5) {
      value = value.replaceRange(3, 3, '-');
    } else if (value.length > 5) {
      value = value.replaceRange(3, 3, '-');
      value = value.replaceRange(6, 6, '-');
    }
    if (value.length > 11) {
      value = value.substring(0, 11);
    }
    return value;
  }

  Widget _buildFilePickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 60),
      child: GestureDetector(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            setState(() {
              _selectedFile = result;
              _selectedFileName = result.files.single.name;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.attach_file),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  _selectedFileName ?? 'Attach File',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileThumbnail() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file),
          SizedBox(width: 10),
          Text(_selectedFileName ?? ''),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          _saveClientDataToFirebase();
          Navigator.pop(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text('Add Client'),
    );
  }

  void _saveClientDataToFirebase() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('clients').add({
        'Full Legal Name': _formData['Full Legal Name'],
        'Address': _formData['Address'],
        'Email': _formData['Email'],
        'Date of Birth': _formData['Date of Birth'],
        'SSN': _formData['SSN'],
        'File': _selectedFile?.files.single.bytes, // Save file as bytes (or handle file upload as needed)
      });
    } catch (e) {
      print('Error saving client data to Firebase: $e');
    }
  }
}
