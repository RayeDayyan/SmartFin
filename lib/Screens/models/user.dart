class AppUser {
  final String name;
  final String email;
  final String organization;
  final String phone;
  final String pass;
  String? role;
  String? profile;

  AppUser({
    required this.name,
    required this.email,
    required this.organization,
    required this.phone,
    required this.pass,
    this.role,
    this.profile,
  });

  // Create an AppUser object from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'],
      email: json['email'],
      organization: json['organization'],
      phone: json['phone'],
      pass: json['password'],
      role: json['role'],
      profile: json['profile'] ?? null,
    );
  }

  // Convert AppUser object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'organization': organization,
      'password': pass,
      'phone': phone,
      'role': role ?? 'client',
    };
  }


}
