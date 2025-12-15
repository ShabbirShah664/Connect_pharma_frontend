// lib/features/home/views/user_profile_page.dart

import 'package:flutter/material.dart';
import '../../../widgets/custom_form_fields.dart' as CustomWidgets; // FIX
// ... (rest of imports)

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  void _logout() {
    // Placeholder for actual logout logic
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // ... (Your profile display widgets)
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User Profile Data Here'),
              const SizedBox(height: 50),
              
              // FIX 26: Use CustomWidgets prefix
              CustomWidgets.CustomButton(
                text: 'Logout',
                onPressed: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}