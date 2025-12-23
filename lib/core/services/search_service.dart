import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/services/api_constants.dart'; // <--- MUST HAVE THIS

class SearchService {
  // Ensure 'query' is passed as a parameter here!
  static Future<List<dynamic>> searchPharmacies(String query) async {
    try {
      // Safely encode the query to handle spaces
      final encodedQuery = Uri.encodeComponent(query);
      final url = '${ApiConstants.BASE_URL}/search?q=$encodedQuery';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to perform search: $e');
    }
  }
}