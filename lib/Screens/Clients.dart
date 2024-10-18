import 'package:flutter/material.dart';
import 'package:smartfin_guide/Controllers/Services/firestore_service.dart';
import 'package:smartfin_guide/Screens/InboxScreen.dart';
import 'package:smartfin_guide/Screens/models/user.dart';

class AdminClientList extends StatefulWidget {
  @override
  _AdminClientListState createState() => _AdminClientListState();
}

class _AdminClientListState extends State<AdminClientList> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<AppUser> _filterClients(List<AppUser> clients) {
    return clients
        .where((client) =>
    client.name.toLowerCase().contains(_searchQuery) ||
        client.email.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clients"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search clients...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AppUser>>(
              stream: _firestoreService.getClients(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final clients = _filterClients(snapshot.data!);

                return ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://via.placeholder.com/150'), // Replace with actual image URLs from Firestore
                          radius: 28,
                        ),
                        title: Text(client.name),
                        subtitle: Text(client.email),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdminChatScreen(clientEmail: client.email),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
