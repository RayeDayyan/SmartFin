import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> titles = [
    'Meeting Reminder',
    'New Client Added',
    'System Update',
    'Task Deadline Approaching',
    'Feedback Received',
  ];

  final List<String> descriptions = [
    'Don’t forget the meeting at 3 PM today.',
    'A new client has been added to the system.',
    'System update available. Please update.',
    'The deadline for the task is approaching soon.',
    'You have received new feedback.',
  ];

  final List<IconData> icons = [
    Icons.access_alarm,
    Icons.person_add,
    Icons.system_update,
    Icons.timer,
    Icons.feedback,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Notifications', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: ListTile(
              leading: Icon(
                icons[index],
                color: Colors.red,
              ),
              title: Text(titles[index], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(descriptions[index]),
            ),
          );
        },
      ),
    );
  }
}
