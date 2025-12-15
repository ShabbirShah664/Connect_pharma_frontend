// lib/core/services/profile_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'auth_api_service.dart';

class ProfileApiService {
  final AuthApiService _authService = AuthApiService();

  Future<Map<String, dynamic>> fetchProfile() async {
    final url = Uri.parse('$kBaseUrl$kProfileEndpoint');
    try {
      final response = await http.get(
        url,
        // FIX: Use the public getheaders method
        headers: await _authService.getHeaders(), 
      );
      // ... (rest of logic)
      return {'success': true, 'data': {'name': 'User Name', 'email': 'user@example.com'}};
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }
}