// lib/data/models/request_model.dart

class RequestModel {
  final String id;
  final String userId;
  final String medicineName;
  final String status; // 'SEARCHING', 'ACCEPTED', etc.
  final Map<String, dynamic> userLocation;
  final int radius;
  final List<dynamic> responses;
  final DateTime? createdAt;

  RequestModel({
    required this.id,
    required this.userId,
    required this.medicineName,
    required this.status,
    required this.userLocation,
    required this.radius,
    required this.responses,
    this.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      medicineName: json['medicineName'] ?? json['medicineDetails'] ?? '',
      status: json['status'] ?? 'pending',
      userLocation: json['userLocation'] != null 
          ? Map<String, dynamic>.from(json['userLocation']) 
          : {},
      radius: json['radius'] ?? 5,
      responses: json['responses'] ?? [],
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] is String ? DateTime.parse(json['createdAt']) : null)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'medicineName': medicineName,
      'status': status,
      'userLocation': userLocation,
      'radius': radius,
      'responses': responses,
    };
  }
}