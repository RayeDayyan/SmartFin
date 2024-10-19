import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartfin_guide/Controllers/Services/firestore_service.dart';
import 'package:smartfin_guide/Screens/models/message.dart';

class ClientChatScreen extends StatefulWidget {
  @override
  _ClientChatScreenState createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;
  bool _hasError = false;
  List<Message> _messages = []; // Store messages locally

  @override
  Widget build(BuildContext context) {
    final String clientEmail = FirebaseAuth.instance.currentUser!.email!;
    final String adminEmail = 'admin123@gmail.com'; // Replace with actual admin email
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Admin avatar here
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Text(
                adminEmail,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<List<Message>>(
                  stream: _firestoreService.getMessages(clientEmail, adminEmail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No messages yet.'));
                    }

                    final messages = snapshot.data!;
                    _messages = messages; // Update local messages list

                    return ListView.builder(
                      reverse: true,
                      itemCount: _messages.length + (_isSending ? 1 : 0), // Add 1 for the unsent message
                      itemBuilder: (context, index) {
                        if (_isSending && index == 0) {
                          // Render the unsent message at the top if still sending
                          return _buildMessage(
                            _messageController.text,
                            false,
                            DateTime.now(),
                            screenWidth,
                            true,
                          );
                        }

                        // Render the actual messages from Firestore
                        final message = _messages[index - (_isSending ? 1 : 0)]; // Adjust index
                        return _buildMessage(
                          message.message,
                          message.isAdmin,
                          message.timestamp,
                          screenWidth,
                          false,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // Text field container
          Container(
            padding: EdgeInsets.all(screenWidth * 0.02),
            color: Colors.white,
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
                      errorText: _hasError ? "Message failed to send" : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.trim().isEmpty) return;

                    setState(() {
                      _isSending = true;
                      _hasError = false;
                    });

                    try {
                      await _firestoreService.sendMessage(
                        message: _messageController.text,
                        senderEmail: clientEmail,
                        receiverEmail: adminEmail,
                        isAdmin: false,
                      );

                      _messageController.clear();
                      setState(() {
                        _isSending = false;
                      });
                    } catch (e) {
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
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isAdmin, DateTime timestamp, double screenWidth, bool isSending) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02, horizontal: screenWidth * 0.04,
      ),
      child: Align(
        alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.7,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.03,
              horizontal: screenWidth * 0.04,
            ),
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
              crossAxisAlignment: isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isAdmin ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  '${timestamp.hour}:${timestamp.minute}',
                  style: TextStyle(
                    color: isAdmin ? Colors.white : Colors.black,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
                if (isSending)
                  Icon(
                    Icons.access_time,
                    size: screenWidth * 0.04,
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
