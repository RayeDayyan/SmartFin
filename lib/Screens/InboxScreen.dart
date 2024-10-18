import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartfin_guide/Controllers/Services/firestore_service.dart';
import 'package:smartfin_guide/Screens/models/message.dart';

class AdminChatScreen extends StatefulWidget {
  final String clientEmail;

  AdminChatScreen({required this.clientEmail});

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final String adminEmail = FirebaseAuth.instance.currentUser!.email!;

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Client avatar here
            ),
            SizedBox(width: screenWidth * 0.02), // Responsive spacing
            Expanded(
              child: Text(
                widget.clientEmail,
                overflow: TextOverflow.ellipsis, // Prevents text overflow
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _firestoreService.getMessages(widget.clientEmail, adminEmail),
              builder: (context, snapshot) {
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
                      return _buildMessage(
                          message.message,
                          message.isAdmin,
                          DateTime.now(), // Replace with actual timestamp
                          screenWidth,
                          false // Messages from Firestore are already sent
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      errorText: _hasError ? "Message failed to send" : null, // Show error text
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.trim().isEmpty) return;

                    // Clear any previous error state
                    setState(() {
                      _isSending = true;
                      _hasError = false;
                    });

                    try {
                      // Attempt to send the message
                      await _firestoreService.sendMessage(
                        message: _messageController.text,
                        senderEmail: adminEmail,
                        receiverEmail: widget.clientEmail,
                        isAdmin: true,
                      );

                      // Clear the message controller and reset sending state
                      _messageController.clear();
                      setState(() {
                        _isSending = false;
                      });
                    } catch (e) {
                      // Handle the error and show the error message
                      setState(() {
                        _hasError = true;
                        _isSending = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          if (_isSending)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildMessage(
                _messageController.text,
                true,
                DateTime.now(),
                screenWidth,
                true, // Show clock icon for unsent messages
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isAdmin, DateTime timestamp, double screenWidth, bool isSending) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.02, horizontal: screenWidth * 0.04), // Responsive padding
      child: Align(
        alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.7, // Limit width to 70% of the screen width
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.03,
              horizontal: screenWidth * 0.04,
            ), // Responsive padding
            decoration: BoxDecoration(
              color: isAdmin ? Colors.red : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomLeft: isAdmin ? Radius.circular(15.0) : Radius.zero,
                bottomRight: isAdmin ? Radius.zero : Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment:
              isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isAdmin ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01), // Responsive spacing
                Text(
                  '${timestamp.hour}:${timestamp.minute}',
                  style: TextStyle(
                    color: isAdmin ? Colors.white : Colors.black,
                    fontSize: screenWidth * 0.03, // Responsive font size
                  ),
                ),
                if (isSending) // Show clock icon if message is being sent
                  Icon(
                    Icons.access_time,
                    size: screenWidth * 0.04, // Small clock icon
                    color: isAdmin ? Colors.white : Colors.black,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
