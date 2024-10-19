import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.subscribeToTopic("all_users");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Send Update',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLines: 5,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _sendUpdate();
                        },
                        child: Text(
                          'Send Update',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendUpdate() async {
    final title = _titleController.text;
    final message = _messageController.text;

    if (title.isNotEmpty && message.isNotEmpty) {
      // Send the notification to all users
      await _sendPushNotification(title, message);

      // Save the update to Firestore
      await FirebaseFirestore.instance.collection('updates').add({
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update sent successfully!')),
      );

      // Clear the text fields
      _titleController.clear();
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  Future<void> _sendPushNotification(String title, String message) async {
    final jsonString = await rootBundle.loadString('assets/smartfinguide.json');
    final serviceAccount = ServiceAccountCredentials.fromJson(jsonDecode(jsonString));

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    obtainAccessCredentialsViaServiceAccount(serviceAccount, scopes, http.Client())
        .then((AccessCredentials credentials) async {
      try {
        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/smartfinguide/messages:send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${credentials.accessToken.data}',
          },
          body: jsonEncode({
            'message': {
              'topic': 'all_users',
              'notification': {
                'title': title,
                'body': message,
              },
            },
          }),
        );

        if (response.statusCode == 200) {
          print("Notification sent successfully.");
        } else {
          print("Failed to send notification. Status Code: ${response.statusCode}");
          print("Response Body: ${response.body}");
        }
      } catch (e) {
        print("Error sending notification: $e");
      }
    });
  }
}
