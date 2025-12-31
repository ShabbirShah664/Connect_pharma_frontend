// lib/core/services/pharmacist_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/services/api_constants.dart';
import 'package:flutter_application_1/data/models/request_model.dart';
import 'package:flutter_application_1/data/models/pharmacist.dart';

class PharmacistApiService {
 
 


  // Primary login method used throughout the app
  Future<Pharmacist> login(String email, String password) async {
    final uri = Uri.parse('${ApiConstants.BASE_URL}/auth/Pharmacist/login');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      // Accept either { data: { ... } } or direct object
      final Map<String, dynamic> data =
          (body['data'] is Map<String, dynamic>) ? body['data'] as Map<String, dynamic> : body;

      return Pharmacist.fromJson(data);
    } else {
      String message = 'Login failed (${response.statusCode})';
      try {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body.containsKey('message')) message = body['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }

  // Alias methods to match different call sites in the project
  Future<Pharmacist> pharmacist_login(String email, String password) =>
      login(email, password);

  Future<Pharmacist> loginPharmacist(String email, String password) =>
      login(email, password);

  // Fetch all pending medicine requests within the pharmacist's area
  static Future<List<RequestModel>> getPendingRequests(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.BASE_URL}/requests/available'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => RequestModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load pending requests');
    }
  }

  // Update request status (Accept/Reject) and provide info
  static Future<void> respondToRequest({
    required String token,
    required String requestId,
    required String status, // 'AVAILABLE' or 'NOT_AVAILABLE'
    required String pharmacyName,
    required Map<String, double> location, // { 'latitude': ..., 'longitude': ... }
    String? suggestedMedicine,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/requests/$requestId/respond'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': status,
        'pharmacyName': pharmacyName,
        'location': location,
        'suggestedMedicine': suggestedMedicine,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to record response');
    }
  }

  // Alias for UI consistency if needed
  Future<List<RequestModel>> fetchAvailableRequests(String token) => getPendingRequests(token);

  // Register a new pharmacist/pharmacy
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String contactNumber,
    required String licenseNumber,
    required String address,
  }) async {
    final uri = Uri.parse('${ApiConstants.BASE_URL}/auth/Pharmacist/signup');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'contactNumber': contactNumber,
        'licenseNumber': licenseNumber,
        'address': address,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      String message = 'Registration failed (${response.statusCode})';
      try {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body.containsKey('error')) message = body['error'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }
}