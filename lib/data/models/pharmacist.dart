class Pharmacist {
  final String id;
  final String name;
  final String email;
  final String pharmacyName;
  final String role;
  final String? token;

  Pharmacist({
    required this.id,
    required this.name,
    required this.email,
    required this.pharmacyName,
    required this.role,
    this.token,
  });

  factory Pharmacist.fromJson(Map<String, dynamic> json) {
    // If backend returns { user: { ... }, token: '...' }
    final userData = json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : json;
    
    return Pharmacist(
      id: userData['id'] ?? userData['uid'] ?? json['uid'] ?? '',
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      pharmacyName: userData['pharmacyName'] ?? userData['name'] ?? 'Unknown Pharmacy',
      role: userData['role'] ?? json['role'] ?? 'pharmacist',
      token: json['token'],
    );
  }
}