import 'dart:convert';

class AppUser {
  final String id;
  final String name;
  final String email;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
  });

  // Create an AppUser object from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert AppUser object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
