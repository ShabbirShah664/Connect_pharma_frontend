// lib/core/services/user_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/services/api_constants.dart';
import 'package:flutter_application_1/data/models/medical_record_model.dart';
import 'package:flutter_application_1/data/models/request_model.dart';
import 'package:flutter_application_1/data/models/user_model.dart';
class UserApiService {
  
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.AUTH_LOGIN}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Returns the body which typically looks like: 
      // {"token": "eyJ...", "user": {"id": "123", "name": "John", ...}}
      return json.decode(response.body);
    } else {
      // Attempt to get the error message from the backend response
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Login failed. Please check your credentials.');
    }
  }
  // 1. Fetch the logged-in user's profile data
  static Future<UserModel> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.USER_PROFILE}'),
      headers: {
        'Content-Type': 'application/json', 
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromJson(data['user']); 
    } else {
      throw Exception('Failed to fetch user profile.');
    }
  }

  // 2. Submit a new medicine request (with Mapbox location)
  static Future<void> submitMedicineRequest(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.REQUEST_MEDICINE}'),
      headers: {
        'Content-Type': 'application/json', 
        'Authorization': 'Bearer $token'
      },
      body: json.encode(data),
    );
    if (response.statusCode != 201) {
      final error = json.decode(response.body)['message'] ?? 'Failed to submit request.';
      throw Exception(error);
    }
  }

  // 3. Save metadata for a medical record (after uploading to storage)
  static Future<void> uploadMedicalRecordMetadata(String token, Map<String, dynamic> metadata) async {
      final response = await http.post(
          Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.RECORDS}'),
          headers: {
            'Content-Type': 'application/json', 
            'Authorization': 'Bearer $token'
          },
          body: json.encode(metadata)
      );
      if (response.statusCode != 201) {
          throw Exception('Failed to upload record metadata.');
      }
  }

  // 4. Get a list of all medical records for the user
  static Future<List<MedicalRecordModel>> fetchMedicalRecords(String token) async {
      final response = await http.get(
          Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.RECORDS}'),
          headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
          final List<dynamic> jsonList = json.decode(response.body);
          return jsonList.map((json) => MedicalRecordModel.fromJson(json)).toList();
      } else {
          throw Exception('Failed to fetch medical records.');
      }
  }

  // 5. Fetch history of all medicine requests made by the user
  static Future<List<RequestModel>> fetchUserRequests(String token) async {
    final response = await http.get(
        Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.REQUEST_USER}'),
        headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => RequestModel.fromJson(json)).toList();
    } else {
        throw Exception('Failed to fetch user requests history.');
    }
  }
}