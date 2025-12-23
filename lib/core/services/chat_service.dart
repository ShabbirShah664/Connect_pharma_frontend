// lib/core/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/core/services/api_constants.dart';
class ChatService {
  static Future<List<dynamic>> fetchMessages(String token, String roomId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.BASE_URL}/chat/$roomId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load messages');
  }

  static Future<void> sendMessage(String token, String roomId, String message) async {
    await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/chat/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'roomId': roomId, 'message': message}),
    );
  }
}