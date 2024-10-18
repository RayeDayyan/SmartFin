import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartfin_guide/Controllers/Services/firestore_service.dart';
import 'package:smartfin_guide/Screens/models/message.dart';

class AdminChatScreen extends StatelessWidget {
  final String clientEmail;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _messageController = TextEditingController();

  AdminChatScreen({required this.clientEmail});

  @override
  Widget build(BuildContext context) {
    final String adminEmail = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      appBar: AppBar(title: Text("Chat with $clientEmail")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _firestoreService.getMessages(clientEmail, adminEmail),
              builder: (context, snapshot) {
                // Handle stream connection states
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                } else {
                  final messages = snapshot.data!;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.message),
                        subtitle: Text(message.isAdmin ? "You (Admin)" : "Client"),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _messageController)),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _firestoreService.sendMessage(
                      message: _messageController.text,
                      senderEmail: adminEmail,  // Admin sending
                      receiverEmail: clientEmail,  // Client receiving
                      isAdmin: true,  // Message from admin
                    );
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
