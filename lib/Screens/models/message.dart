import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final bool isAdmin;
  final String message;
  final String receiverEmail;  // Changed to email
  final String senderEmail;    // Changed to email
  final DateTime timestamp;

  Message({
    required this.isAdmin,
    required this.message,
    required this.receiverEmail,
    required this.senderEmail,
    required this.timestamp,
  });

  // Create a Message object from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isAdmin: json['isAdmin'],
      message: json['message'],
      receiverEmail: json['receiverEmail'],  // Updated key to email
      senderEmail: json['senderEmail'],      // Updated key to email
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'isAdmin': isAdmin,
      'message': message,
      'receiverEmail': receiverEmail,  // Updated key to email
      'senderEmail': senderEmail,      // Updated key to email
      'timestamp': timestamp,
    };
  }
}
