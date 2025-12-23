// lib/data/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'user' or 'pharmacist'

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert JSON (from Node.js/Firestore) into a Dart Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  // Convert a Dart Object into JSON (to send to the API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}