import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class InboxScreen extends StatefulWidget {
  final String clientName;
  final String clientImage;
  final String clientId;

  InboxScreen({
    required this.clientName,
    required this.clientImage,
    required this.clientId, required clientMessages, required Map client,
  });

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController _messageController = TextEditingController();
  FilePickerResult? _selectedFile;
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    if (widget.clientId.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Client ID is empty. Please provide a valid client ID.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.clientImage),
            ),
            SizedBox(width: 10),
            Text(widget.clientName),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Implement audio call functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.clientId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return _buildMessage(
                      message['text'],
                      message['isSentByAdmin'],
                      message['timestamp'] != null
                          ? (message['timestamp'] as Timestamp).toDate()
                          : DateTime.now(),
                    );
                  },
                );
              },
            ),
          ),
          if (_selectedFile != null) _buildAttachmentPreview(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isSentByAdmin, DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isSentByAdmin ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: isSentByAdmin ? Colors.red : Colors.grey[300],
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment:
                isSentByAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(color: isSentByAdmin ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5),
              Text(
                '${timestamp.hour}:${timestamp.minute}',
                style: TextStyle(
                    color: isSentByAdmin ? Colors.white : Colors.black, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: _pickFile,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onSubmitted: (text) {
                _sendMessage();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.red),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.clientId)
          .collection('messages')
          .add({
        'text': message,
        'isSentByAdmin': true, // Assuming the message is sent by the admin
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result;
        _selectedFileName = result.files.single.name;
      });
    }
  }

  Widget _buildAttachmentPreview() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.attach_file, size: 40),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              _selectedFileName!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
