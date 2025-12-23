// lib/data/models/medical_record_model.dart

class MedicalRecordModel {
  final String id;
  final String userId;
  final String title;
  final String storageUrl; // URL pointing to Firebase Storage or the file host
  final String recordType; // e.g., 'Prescription', 'Lab Report', 'Vaccination'
  final DateTime? createdAt;

  MedicalRecordModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.storageUrl,
    required this.recordType,
    this.createdAt,
  });

  // Factory constructor to create a Model from JSON (API Response)
  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? 'Untitled Record',
      storageUrl: json['storageUrl'] ?? '',
      recordType: json['recordType'] ?? 'Other',
      // Handles Firestore timestamps or ISO strings
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString()) 
          : null,
    );
  }

  // Method to convert the Model back to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'storageUrl': storageUrl,
      'recordType': recordType,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}