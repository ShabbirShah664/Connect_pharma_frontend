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
      Uri.parse('${ApiConstants.BASE_URL}/auth/User/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? errorData['error'] ?? 'Login failed.');
    }
  }

  static Future<void> registerUser(String name, String email, String password, String contactNumber) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/auth/User/signup'), 
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'contactNumber': contactNumber,
      }),
    );

    if (response.statusCode != 201) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'Registration failed.');
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

  // 6. Get status of a specific request
  static Future<Map<String, dynamic>> getRequestStatus(String token, String requestId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.BASE_URL}/requests/$requestId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get request status.');
    }
  }

  // 7. Expand search radius
  static Future<void> expandRequestRadius(String token, String requestId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/requests/$requestId/expand'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
       throw Exception('Failed to expand radius.');
    }
  }

  // 8. Broadcast a new request to nearby pharmacies
  static Future<Map<String, dynamic>> broadcastRequest(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/requests/broadcast'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      final errorMessage = errorData['error'] ?? errorData['message'] ?? 'Failed to broadcast request.';
      throw Exception(errorMessage);
    }
  }
}
