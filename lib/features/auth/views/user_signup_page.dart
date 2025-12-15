// lib/features/auth/views/user_signup_page.dart

import 'package:flutter/material.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../routes/app_routes.dart';
// FIX 1: Import custom widgets with a prefix to resolve 'Method not found' errors
import '../../../widgets/custom_form_fields.dart' as CustomWidgets; 

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({super.key});
  
  // FIX 1: Missing createState implementation
  @override
  State<UserSignupPage> createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  String _selectedRole = 'User'; 
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthApiService _authService = AuthApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    // ... (Your signup logic)
    setState(() { _isLoading = true; });
    await Future.delayed(const Duration(seconds: 1)); 
    setState(() { _isLoading = false; });
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.userHome);
    }
  }

  // FIX 18: build method must return a widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            // FIX 12-15: Use CustomWidgets prefix
            CustomWidgets.CustomTextField(controller: _nameController, labelText: 'Full Name', icon: Icons.person),
            const SizedBox(height: 16),
            CustomWidgets.CustomTextField(controller: _emailController, labelText: 'Email Address', icon: Icons.email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            CustomWidgets.CustomTextField(controller: _contactController, labelText: 'Contact Number', icon: Icons.phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            CustomWidgets.CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 20),

            // Radio Buttons for role selection (assuming logic is similar to login page)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('User'),
                    value: 'User',
                    groupValue: _selectedRole,
                    onChanged: (String? value) {
                      setState(() { _selectedRole = value!; });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Pharmacist'),
                    value: 'Pharmacist',
                    groupValue: _selectedRole,
                    onChanged: (String? value) {
                      setState(() { _selectedRole = value!; });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // FIX 16: Use CustomWidgets prefix
            CustomWidgets.CustomButton(
              text: 'Create Account',
              isLoading: _isLoading,
              onPressed: _signup,
            ),
            
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const Text('Already have an account? Log In'),
            ),
          ],
        ),
      ),
    ); 
  }
}