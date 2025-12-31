import 'package:flutter/material.dart';

class PharmacistChatsPage extends StatelessWidget {
  const PharmacistChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pharmacy Chats', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final names = ['Thomas Wilson', 'Sarah Parker', 'James Miller'];
          final lastMsgs = ['Is the medicine available?', 'Thank you for the suggestion!', 'When can it be delivered?'];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(names[index][0], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF007BFF))),
            ),
            title: Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(lastMsgs[index], maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('12:30 PM', style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 5),
                CircleAvatar(radius: 8, backgroundColor: Color(0xFF007BFF), child: Text('1', style: TextStyle(fontSize: 10, color: Colors.white))),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chat Detail coming soon!')));
            },
          );
        },
      ),
    );
  }
}
