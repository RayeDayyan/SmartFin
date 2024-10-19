import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Screens/models/message.dart';
import '../../Screens/models/user.dart';

class FirestoreService {
  // Send a message
  Future<void> sendMessage({
    required String message,
    required String senderEmail,
    required String receiverEmail,
    required bool isAdmin,
  }) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'isAdmin': isAdmin,
      'message': message,
      'senderEmail': senderEmail,      // Sender email (admin or client)
      'receiverEmail': receiverEmail,  // Recipient email (admin or client)
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get a list of clients for the admin
  Stream<List<AppUser>> getClients() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'client')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => AppUser.fromJson(doc.data())).toList());
  }

  // Get messages between an admin and a client
  Stream<List<Message>> getMessages(String clientEmail, String adminEmail) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('receiverEmail', whereIn: [clientEmail, adminEmail])
        .where('senderEmail', whereIn: [clientEmail, adminEmail])
        .orderBy('timestamp', descending: true) // Order by latest messages
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Stream<List<Message>> getRecentMessages(String clientEmail) {
    return FirebaseFirestore.instance
        .collection('messages')  // Assuming 'messages' is your collection name
        .where('receiverEmail', isEqualTo: clientEmail)
        .orderBy('timestamp', descending: true)
        .limit(10)  // Fetch the 10 most recent messages
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Stream<List<AppUser>> getadmins() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => AppUser.fromJson(doc.data())).toList());
  }

}
