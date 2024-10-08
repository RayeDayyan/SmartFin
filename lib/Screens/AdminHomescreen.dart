import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartfin_guide/Screens/Clients.dart';
import 'package:smartfin_guide/Screens/InboxScreen.dart';
import 'package:smartfin_guide/Screens/NotificationScreen.dart';
import 'package:smartfin_guide/Screens/ProfileScreen.dart';
import 'package:smartfin_guide/Screens/UpdateScreen.dart';

class AdminHomeScreen extends StatefulWidget {
  final User user;

  AdminHomeScreen({required this.user});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> catNames = [
    'All clients',
    'To be notified',
    'Meetings',
    'Import',
    'New clients',
    'Removed',
  ];

  final List<Color> catColors = [
    Color.fromARGB(255, 255, 200, 2),
    Color.fromARGB(255, 87, 205, 118),
    Color.fromARGB(255, 67, 202, 243),
    Color.fromARGB(255, 117, 229, 99),
    Color.fromARGB(255, 194, 127, 240),
    Color.fromARGB(255, 252, 124, 124),
  ];

  final List<Icon> catIcons = [
    Icon(Icons.people, color: Colors.white, size: 30),
    Icon(Icons.notification_add_outlined, color: Colors.white, size: 30),
    Icon(Icons.meeting_room, color: Colors.white, size: 30),
    Icon(Icons.import_export_outlined, color: Colors.white, size: 30),
    Icon(Icons.new_label_rounded, color: Colors.white, size: 30),
    Icon(Icons.delete, color: Colors.white, size: 30),
  ];

  final List<String> clientImages = [
    'https://i.pinimg.com/236x/da/fd/f2/dafdf25168edcb2f0e1d8702797946cc.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCo5rBr2N6uQKaltnIgwzmdJxCBRhodVB-sQ&s',
    'https://media.glamourmagazine.co.uk/photos/643911c5faffaaf0fce7d598/1:1/w_1280,h_1280,c_limit/SOFT%20GIRL%20AESTHETIC%20140423%20rachelteetyler_L.jpeg',
    'https://knowledgeenthusiast.com/wp-content/uploads/2022/04/pexels-photo-6694422.jpeg',
    'https://i.pinimg.com/236x/da/fd/f2/dafdf25168edcb2f0e1d8702797946cc.jpg',
  ];

  final List<String> clientMessages = [
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
  ];

  final List<String> clientTimestamps = [
    '12:01 PM',
    '1:32 PM',
    '11:10 PM',
    '10:31 PM',
    '10:31 AM',
  ];

  Future<bool> _onWillPop() async {
    return false; // Prevent back navigation
  }

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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: widget.user.photoURL != null
                                ? NetworkImage(widget.user.photoURL!)
                                : AssetImage('assets/default_avatar.png')
                                    as ImageProvider,
                            radius: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      NotificationScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                        position: offsetAnimation,
                                        child: child);
                                  },
                                ),
                              );
                            },
                            child:
                                Icon(Icons.notifications, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 3, bottom: 15),
                        child: Text(
                          'Hi, ${widget.user.displayName ?? 'User'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 17),
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: catNames.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      Clients(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                        position: offsetAnimation,
                                        child: child);
                                  },
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: catColors[index],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(child: catIcons[index]),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  catNames[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Clients',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Clients(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                        child: Row(
                          children: [
                            Text(
                              'View more',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 180,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      var client = filteredClients[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      InboxScreen(
                                clientName: '',
                                clientImage: '',
                                clientId: '',
                                client: {},
                                clientMessages: null,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(client['image']!),
                                radius: 30,
                              ),
                              SizedBox(height: 10),
                              Text(
                                client['name']!,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                              Text(
                                client['message']!,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              Text(
                                client['timestamp']!,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            UpdateScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Colors.red : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.update,
                color: _currentIndex == 1 ? Colors.red : Colors.grey,
              ),
              label: 'Updates',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 2 ? Colors.red : Colors.grey,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
