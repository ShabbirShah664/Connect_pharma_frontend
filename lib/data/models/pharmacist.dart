class Pharmacist {
  final String id;
  final String name;
  final String email;
  final String pharmacyName;
  final String role;

  Pharmacist({
    required this.id,
    required this.name,
    required this.email,
    required this.pharmacyName,
    required this.role,
  });

  factory Pharmacist.fromJson(Map<String, dynamic> json) {
    return Pharmacist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      pharmacyName: json['pharmacyName'] ?? 'Unknown Pharmacy',
      role: json['role'] ?? 'pharmacist',
    );
  }
}