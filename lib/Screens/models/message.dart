import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final bool isAdmin;
  final String message;
  final String receiverEmail; // Changed to email
  final String senderEmail;   // Changed to email
  final DateTime timestamp;

  Message({
    required this.isAdmin,
    required this.message,
    required this.receiverEmail,
    required this.senderEmail,
    required this.timestamp,
  });

  // Create a Message object from JSON, handle potential null timestamp
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isAdmin: json['isAdmin'] ?? false, // Safeguard with a default value
      message: json['message'] ?? '',
      receiverEmail: json['receiverEmail'] ?? '',
      senderEmail: json['senderEmail'] ?? '',
      timestamp: (json['timestamp'] != null)
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.now(), // Handle null timestamp with a default value
    );
  }

  // Convert Message object to JSON
  Map<String, dynamic> toJson() {
    return {
      'isAdmin': isAdmin,
      'message': message,
      'receiverEmail': receiverEmail,
      'senderEmail': senderEmail,
      'timestamp': Timestamp.fromDate(timestamp), // Ensure conversion to Timestamp
    };
  }
}
