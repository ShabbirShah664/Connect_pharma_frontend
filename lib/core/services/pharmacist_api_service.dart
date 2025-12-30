// lib/core/services/pharmacist_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/services/api_constants.dart';
import 'package:flutter_application_1/data/models/request_model.dart';
import 'package:flutter_application_1/data/models/pharmacist.dart';

class PharmacistApiService {
 
 
  // Primary login method used throughout the app
  Future<Pharmacist> login(String email, String password) async {
    final uri = Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.AUTH_LOGIN}');

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
      Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.REQUEST_AVAILABLE}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => RequestModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load pending requests');
    }
    
  }
  
  

  // Submit a response (alternative/availability) to a request
  static Future<void> respondToRequest(String token, String requestId, String status, String? alternativeMedicine, String? note) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/requests/$requestId/respond'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': status,
        'alternativeMedicine': alternativeMedicine,
        'note': note,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit response');
    }
  }
}