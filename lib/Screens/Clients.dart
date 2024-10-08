import 'package:flutter/material.dart';
import 'package:smartfin_guide/Screens/InboxScreen.dart';
import 'package:smartfin_guide/Screens/AddClientScreen.dart'; // Import the AddClientScreen

class Clients extends StatefulWidget {
  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> clientImages = [
    'https://i.pinimg.com/236x/da/fd/f2/dafdf25168edcb2f0e1d8702797946cc.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCo5rBr2N6uQKaltnIgwzmdJxCBRhodVB-sQ&s',
    'https://media.glamourmagazine.co.uk/photos/643911c5faffaaf0fce7d598/1:1/w_1280,h_1280,c_limit/SOFT%20GIRL%20AESTHETIC%20140423%20rachelteetyler_L.jpeg',
    'https://knowledgeenthusiast.com/wp-content/uploads/2022/04/pexels-photo-6694422.jpeg',
    'https://i.pinimg.com/236x/da/fd/f2/dafdf25168edcb2f0e1d8702797946cc.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCo5rBr2N6uQKaltnIgwzmdJxCBRhodVB-sQ&s',
    'https://media.glamourmagazine.co.uk/photos/643911c5faffaaf0fce7d598/1:1/w_1280,h_1280,c_limit/SOFT%20GIRL%20AESTHETIC%20140423%20rachelteetyler_L.jpeg',
    'https://knowledgeenthusiast.com/wp-content/uploads/2022/04/pexels-photo-6694422.jpeg',
    'https://i.pinimg.com/236x/da/fd/f2/dafdf25168edcb2f0e1d8702797946cc.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCo5rBr2N6uQKaltnIgwzmdJxCBRhodVB-sQ&s',
    'https://media.glamourmagazine.co.uk/photos/643911c5faffaaf0fce7d598/1:1/w_1280,h_1280,c_limit/SOFT%20GIRL%20AESTHETIC%20140423%20rachelteetyler_L.jpeg',
    'https://knowledgeenthusiast.com/wp-content/uploads/2022/04/pexels-photo-6694422.jpeg',
    'https://i.pinimg.com/236x/da/fd/f2/dafdf25168edcb2f0e1d8702797946cc.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCo5rBr2N6uQKaltnIgwzmdJxCBRhodVB-sQ&s',
    'https://media.glamourmagazine.co.uk/photos/643911c5faffaaf0fce7d598/1:1/w_1280,h_1280,c_limit/SOFT%20GIRL%20AESTHETIC%20140423%20rachelteetyler_L.jpeg',
  ];

  final List<String> clientMessages = [
    'Can we meet today?',
    'Sure thing boss..!',
    'How\'s my case?',
    'Submit it by tomorrow',
    'This needs to be discussed',
    'Can we meet today?',
    'Sure thing boss..!',
    'How\'s my case?',
    'Submit it by tomorrow',
    'This needs to be discussed',
    'Can we meet today?',
    'Sure thing boss..!',
    'How\'s my case?',
    'Submit it by tomorrow',
    'This needs to be discussed',
  ];

  final List<String> clientNames = [
    'Soha',
    'John',
    'Liza Ann',
    'Webster',
    'Anna',
    'Soha',
    'John',
    'Liza Ann',
    'Webster',
    'Anna',
    'Soha',
    'John',
    'Liza Ann',
    'Webster',
    'Anna',
  ];

  final List<String> clientTimestamps = [
    '12:01 PM',
    '1:32 PM',
    '11:10 PM',
    '10:31 PM',
    '10:31 AM',
    '12:01 PM',
    '1:32 PM',
    '11:10 PM',
    '10:31 PM',
    '10:31 AM',
    '12:01 PM',
    '1:32 PM',
    '11:10 PM',
    '10:31 PM',
    '10:31 AM',
  ];

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

  List<Map<String, String>> _filterClients() {
    return List.generate(clientNames.length, (index) {
      return {
        'image': clientImages[index],
        'name': clientNames[index],
        'message': clientMessages[index],
        'timestamp': clientTimestamps[index],
      };
    }).where((client) {
      return client['name']!.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var filteredClients = _filterClients();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Clients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: filteredClients.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  InboxScreen(
                            clientImage: filteredClients[index]['image']!,
                            clientName: filteredClients[index]['name']!, clientMessages: null, client: {}, clientId: '',
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(8),
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(filteredClients[index]['image']!),
                          radius: 28,
                        ),
                        title: Text(filteredClients[index]['name']!),
                        subtitle: Text(filteredClients[index]['message']!),
                        trailing: Text(filteredClients[index]['timestamp']!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AddClientScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
