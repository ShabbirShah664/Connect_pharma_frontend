// lib/features/auth/views/user_login_page.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../services/user_api_service.dart';
import '../../../services/pharmacist_api_service.dart';
// Note: You would typically use a shared auth service, but we use dedicated services here.

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userApiService = UserApiService();
  final _pharmacistApiService = PharmacistApiService();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  // State variable to track the selected role (User or Pharmacist)
  String _selectedRole = 'User'; 
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Login Handler: The core logic for connecting Frontend & Backend ---
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      try {
        if (_selectedRole == 'User') {
          // 1. Attempt User Login
          final user = await _userApiService.loginUser(email, password); 
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${user.name}!')),
            );
            // Navigate to User Home Page
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.userHome, 
              (route) => false, 
              arguments: user,
            );
          }

        } else if (_selectedRole == 'Pharmacist') {
          // 2. Attempt Pharmacist Login
          final pharmacist = await _pharmacistApiService.loginPharmacist(email, password); 
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Welcome, ${pharmacist.pharmacyName}!')),
            );
            // Navigate to Pharmacist Home Page
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.pharmacistHome, 
              (route) => false, 
              arguments: pharmacist, // Pass the pharmacist object to the home page
            );
          }
        }

      } catch (e) {
        if (mounted) {
          // Show the specific error message from the API service
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceFirst('Exception: ', 'Login Failed: '))),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
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
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 30),

              // --- Role Selection Toggle ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRoleChip('User', Icons.person, _selectedRole == 'User'),
                  const SizedBox(width: 15),
                  _buildRoleChip('Pharmacist', Icons.local_pharmacy, _selectedRole == 'Pharmacist'),
                ],
              ),
              const SizedBox(height: 30),
              
              // Email Field
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              
              // Password Field
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                isPassword: true,
              ),
              
              const SizedBox(height: 30),

              // Sign In Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20, 
                        child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 18, color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
              ),
              
              const SizedBox(height: 40),

              // Don't Have Account Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?', style: TextStyle(color: AppColors.text)),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.roleSelection);
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Utility Widget for Input Fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(labelText, style: const TextStyle(color: AppColors.text, fontSize: 16)),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword && !_isPasswordVisible,
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.text.withOpacity(0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $labelText';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
  
  // Utility Widget for Role Selection
  Widget _buildRoleChip(String role, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.text.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.text,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}