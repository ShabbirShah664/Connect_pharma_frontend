// lib/features/chat/views/chat_screen.dart

import 'package:flutter/material.dart';
import '../../../widgets/custom_form_fields.dart' as CustomWidgets; // FIX
// ... (rest of imports)

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String partnerName;
  final String partnerId;

  const ChatScreen({super.key, required this.chatRoomId, required this.partnerName, required this.partnerId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      // ... (Your send message logic)
      _messageController.clear();
    }
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            // FIX 27: Use CustomWidgets prefix
            child: CustomWidgets.CustomTextField( 
              controller: _messageController,
              labelText: 'Send a message...',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.partnerName}')),
      body: Column(
        children: <Widget>[
          // Placeholder for message list
          const Expanded(
            child: Center(child: Text('Start chatting...')),
          ),
          _buildInput(),
        ],
      ),
    );
  }
}