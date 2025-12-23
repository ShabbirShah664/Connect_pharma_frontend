// lib/features/auth/views/pharmacist_signup_page.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/pharmacist.dart';
import '../../../core/services/pharmacist_api_service.dart';
import '../../../core/services/auth_api_service.dart';
class PharmacistSignupPage extends StatefulWidget {
  const PharmacistSignupPage({super.key});

  @override
  State<PharmacistSignupPage> createState() => _PharmacistSignupPageState();
}

class _PharmacistSignupPageState extends State<PharmacistSignupPage> {
  // 1. Initialize the API Service to fix the "undefined" error
  final AuthApiService _apiService = AuthApiService();
  
  // 2. Form and Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pharmacyNameController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // 3. Signup Logic
  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Prepare the data Map for the API
    Map<String, dynamic> newPharmacist = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text,
      "pharmacyName": _pharmacyNameController.text.trim(),
      "licenseNumber": _licenseController.text.trim(),
      "role": "pharmacist", // Explicitly setting role for backend logic
    };

    try {
      // Calling the service method we added in the previous step
      await _apiService.registerPharmacist(newPharmacist);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful! Please login to continue.'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to login screen
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pharmacist Registration')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Professional Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                
                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => !v!.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),

                // Pharmacy Name
                TextFormField(
                  controller: _pharmacyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Pharmacy Name',
                    prefixIcon: Icon(Icons.local_pharmacy),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter pharmacy name' : null,
                ),
                const SizedBox(height: 16),

                // License Number
                TextFormField(
                  controller: _licenseController,
                  decoration: const InputDecoration(
                    labelText: 'Pharmacist License Number',
                    prefixIcon: Icon(Icons.verified),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Enter license number' : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v!.length < 6 ? 'Password must be 6+ chars' : null,
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('REGISTER AS PHARMACIST', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pharmacyNameController.dispose();
    _licenseController.dispose();
    super.dispose();
  }
}