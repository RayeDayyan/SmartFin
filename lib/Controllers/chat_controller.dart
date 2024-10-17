// File: controllers/chat_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessageToAllClients(String adminEmail, String message) async {
    final timestamp = DateTime.now();

    // Fetch all clients
    final clientsSnapshot = await _firestore.collection('users').where('role', isEqualTo: 'client').get();

    for (var clientDoc in clientsSnapshot.docs) {
      await _firestore.collection('messages').add({
        'senderId': adminEmail,
        'receiverId': clientDoc['email'], // Use email instead of ID
        'message': message,
        'timestamp': timestamp,
        'isAdmin': true,
      });
    }
  }

  Stream<List<Message>> getMessages(String userEmail) {
    return _firestore.collection('messages')
        .where('receiverId', isEqualTo: userEmail) // Use email here too
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
}

// Message model
class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool isAdmin;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isAdmin,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      timestamp: json['timestamp'],
      isAdmin: json['isAdmin'],
    );
  }
}
