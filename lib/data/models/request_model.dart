// lib/data/models/request_model.dart

class RequestModel {
  final String id;
  final String userId;
  final String? userName;
  final Map<String, dynamic> medicineDetails;
  final String status;
  final Map<String, dynamic> deliveryLocation;
  final String? prescriptionImageUrl;
  final List<dynamic>? responses; // List of offers/responses
  final DateTime? createdAt;

  RequestModel({
    required this.id,
    required this.userId,
    this.userName,
    required this.medicineDetails,
    required this.status,
    required this.deliveryLocation,
    this.prescriptionImageUrl,
    this.responses,
    this.createdAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString(),
      medicineDetails: json['medicineDetails'] is Map 
          ? Map<String, dynamic>.from(json['medicineDetails'])
          : {'name': json['medicineDetails'].toString()},
      status: json['status']?.toString() ?? 'pending',
      deliveryLocation: json['deliveryLocation'] is Map 
          ? Map<String, dynamic>.from(json['deliveryLocation']) 
          : {'address': json['deliveryLocation']?.toString() ?? ''},
      prescriptionImageUrl: json['prescriptionImageUrl']?.toString(),
      responses: (json['responses'] is List) ? List<dynamic>.from(json['responses']) : [],
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'medicineDetails': medicineDetails,
      'status': status,
      'deliveryLocation': deliveryLocation,
      'prescriptionImageUrl': prescriptionImageUrl,
      'responses': responses,
    };
  }
}