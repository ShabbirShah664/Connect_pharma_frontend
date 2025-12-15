// lib/core/services/search_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'auth_api_service.dart';

class SearchApiService {
  final AuthApiService _authService = AuthApiService();

  Future<Map<String, dynamic>> searchMedicine({
    required String medicineName,
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse('$kBaseUrl$kSearchEndpoint');

    try {
      final response = await http.post(
        url,
        // FIX: Use the public getHeaders method
        headers: await _authService.getHeaders(), 
        body: jsonEncode({
          'medicineName': medicineName,
          // FIX: Parameter names match the service definition
          'latitude': latitude, 
          'longitude': longitude,
        }),
      );
      // ... (rest of logic)
      return {'success': true, 'data': []}; // Placeholder response
    } catch (e) {
      throw Exception('Error searching medicine: $e');
    }
  }
}