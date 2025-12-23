import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/services/api_constants.dart';

class AuthApiService {
  // Added this to fix the 'getHeaders' undefined error
  Future<Map<String, String>> getHeaders() async {
    // For now, return basic headers. 
    // Later, you can add 'Authorization': 'Bearer $token' here
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<void> registerPharmacist(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.AUTH_SIGNUP}'),
      headers: await getHeaders(),
      body: json.encode(data),
    );

    if (response.statusCode != 201) {
      throw Exception(json.decode(response.body)['message'] ?? 'Signup failed');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}${ApiConstants.AUTH_LOGIN}'),
      headers: await getHeaders(),
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Login failed');
    }
  }
}