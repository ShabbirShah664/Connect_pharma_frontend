// lib/features/auth/views/role_select_page.dart

import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class RoleSelectionPage extends StatelessWidget { 
  final bool isSignup;
  const RoleSelectionPage({super.key, this.isSignup = true}); 

  void _navigateToNext(BuildContext context, String role) {
    // FIX 21, 22: Using the correct route names (signup and login)
    final String nextRoute = isSignup ? AppRoutes.signup : AppRoutes.login; 
    
    Navigator.pushReplacementNamed(
      context,
      nextRoute,
      arguments: role,
    );
  }

  void _toggleMode(BuildContext context) {
    // FIX 23: Using the correct route name (roleSelection)
    Navigator.pushReplacementNamed(context, AppRoutes.roleSelection, arguments: !isSignup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isSignup ? 'Select Signup Role' : 'Select Login Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToNext(context, 'User'),
              child: const Text('I am a User'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToNext(context, 'Pharmacist'),
              child: const Text('I am a Pharmacist'),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => _toggleMode(context),
              child: Text(isSignup 
                ? 'Already have an account? Go to Login' 
                : 'Need an account? Go to Signup'),
            ),
          ],
        ),
      ),
    );
  }
}