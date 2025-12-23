// lib/data/models/request_model.dart

class RequestModel {
  final String id;
  final String userId;
  final String medicineDetails;
  final String status; // 'pending', 'accepted', 'rejected'
  final Map<String, dynamic> deliveryLocation;
  final String? pharmacistId;
  final double? estimatedPrice;
  final DateTime? createdAt;

  RequestModel({
    required this.id,
    required this.userId,
    required this.medicineDetails,
    required this.status,
    required this.deliveryLocation,
    this.pharmacistId,
    this.estimatedPrice,
    this.createdAt,
  });

  // Convert JSON from the Backend (Node.js API) to this Dart Model
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      medicineDetails: json['medicineDetails'] ?? '',
      status: json['status'] ?? 'pending',
      // Handles the nested location object { lat, lng, address }
      deliveryLocation: json['deliveryLocation'] != null 
          ? Map<String, dynamic>.from(json['deliveryLocation']) 
          : {},
      pharmacistId: json['pharmacistId'],
      // Handles price conversion safely from int or double
      estimatedPrice: json['estimatedPrice'] != null 
          ? (json['estimatedPrice'] as num).toDouble() 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  // Convert this Model to JSON (Useful if you send data back to the API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'medicineDetails': medicineDetails,
      'status': status,
      'deliveryLocation': deliveryLocation,
      'pharmacistId': pharmacistId,
      'estimatedPrice': estimatedPrice,
    };
  }
}