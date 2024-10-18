import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartfin_guide/Controllers/Services/firestore_service.dart';
import 'package:smartfin_guide/Screens/models/message.dart';

class ClientChatScreen extends StatelessWidget {
  final String adminEmail = 'admin123@gmail.com'; // Replace with actual admin email
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String clientEmail = FirebaseAuth.instance.currentUser!.email!;

    return Scaffold(
      appBar: AppBar(title: Text("Chat with Admin")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _firestoreService.getMessages(clientEmail, adminEmail),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final messages = snapshot.data!;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.message),
                      subtitle: Text(message.isAdmin ? "Admin" : "You"),
                    );
                  },
                );
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
                      senderEmail: clientEmail,
                      receiverEmail: adminEmail,
                      isAdmin: false, // Client sending message
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
