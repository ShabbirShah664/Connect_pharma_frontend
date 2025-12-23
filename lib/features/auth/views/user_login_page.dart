// lib/features/auth/views/user_login_page.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter_application_1/core/services/user_api_service.dart';
import 'package:flutter_application_1/core/services/pharmacist_api_service.dart';
import 'package:flutter_application_1/core/services/api_constants.dart';
import 'package:flutter_application_1/data/models/pharmacist.dart';
import 'package:flutter_application_1/data/models/user_model.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  
  // 🛠️ FIX: Initialize the Pharmacist Service instance here
  final PharmacistApiService _pharmacistApiService = PharmacistApiService();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _selectedRole = 'User'; 
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
      
    try {
      if (_selectedRole == 'User') {
        // 1. User Login (Calling static method)
        final result = await UserApiService.loginUser(email, password);
        
        // 🛠️ FIX: Cast to Map to ensure fromJson works correctly
        final user = UserModel.fromJson(Map<String, dynamic>.from(result['user']));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${user.name}!')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.userHome, 
            (route) => false, 
            arguments: user,
          );
        }
      } else {
        // 2. Pharmacist Login (Calling instance method)
        // 🛠️ FIX: Using the instance variable _pharmacistApiService
        final pharmacist = await _pharmacistApiService.loginPharmacist(email, password); 
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${pharmacist.pharmacyName}!')),
          );
          // 🛠️ FIX: AppRoutes.pharmacistHome must be defined in app_routes.dart
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.pharmacistHome, 
            (route) => false, 
            arguments: pharmacist,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign In', style: TextStyle(color: AppColors.text)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRoleChip('User', Icons.person, _selectedRole == 'User'),
                  const SizedBox(width: 15),
                  _buildRoleChip('Pharmacist', Icons.local_pharmacy, _selectedRole == 'Pharmacist'),
                ],
              ),
              const SizedBox(height: 30),
              _buildTextField(controller: _emailController, labelText: 'Email', hintText: 'Enter email'),
              _buildTextField(controller: _passwordController, labelText: 'Password', hintText: 'Enter password', isPassword: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 15)),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SIGN IN', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText, required String hintText, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: isPassword ? IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible)) : null,
      ),
    );
  }

  Widget _buildRoleChip(String role, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Chip(
        avatar: Icon(icon, color: isSelected ? Colors.white : Colors.black),
        label: Text(role),
        backgroundColor: isSelected ? AppColors.primary : Colors.grey[200],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}