import 'package:flutter/material.dart';
import 'package:smartfin_guide/Controllers/Services/firestore_service.dart';
import 'package:smartfin_guide/Screens/models/user.dart';
import 'admin_chat_screen.dart';

class AdminClientList extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clients")),
      body: StreamBuilder<List<AppUser>>(
        stream: _firestoreService.getClients(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final clients = snapshot.data!;

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return ListTile(
                title: Text(client.name),
                subtitle: Text(client.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminChatScreen(clientEmail: client.email),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
