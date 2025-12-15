// lib/features/auth/views/pharmacist_signup_page.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../models/pharmacist.dart';
import '../../../services/pharmacist_api_service.dart';

class PharmacistSignupPage extends StatefulWidget {
  const PharmacistSignupPage({super.key});

  @override
  State<PharmacistSignupPage> createState() => _PharmacistSignupPageState();
}

class _PharmacistSignupPageState extends State<PharmacistSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = PharmacistApiService();
  
  // Text Controllers corresponding to the form fields
  final _pharmacyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenceNumberController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();

  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _pharmacyNameController.dispose();
    _emailController.dispose();
    _licenceNumberController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // --- Registration Handler: Backend Integration Point ---
  void _handleRegistration() async {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      setState(() {
        _isLoading = true;
      });

      final newPharmacist = Pharmacist(
        pharmacyName: _pharmacyNameController.text.trim(),
        email: _emailController.text.trim(),
        licenceNumber: _licenceNumberController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        address: _addressController.text.trim(),
      );

      try {
        await _apiService.registerPharmacist(newPharmacist);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful! Please sign in.')),
          );
          // Navigate to Login Page after successful signup
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login, 
            (route) => false // Clear the back stack
          );
        }

      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and policy.')),
      );
    }
  }

  // --- Utility Widget for Input Fields (Matches the style in the image) ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(labelText, style: const TextStyle(color: AppColors.text, fontSize: 14)),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.text),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.text.withOpacity(0.5)),
            filled: true,
            fillColor: AppColors.white, // Light gray/white background for inputs
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
            if (labelText == 'Email' && !value.contains('@')) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  // Utility for social buttons
  Widget _buildSocialButton(String label, IconData icon, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 28), // Simplified icon for visual matching
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Signup Pharmacy', style: TextStyle(color: AppColors.text)),
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
              // Logo/Title section from the image
              const Text(
                'CONNECT-PHARMA',
                style: TextStyle(
                  color: AppColors.primary, 
                  fontSize: 24, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const Text(
                'Find Your Medicine Fast and Easy',
                style: TextStyle(color: AppColors.text, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                'Register Your Pharmacy',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),

              // Input Fields (Matching the field names from the image)
              _buildTextField(
                controller: _pharmacyNameController,
                labelText: 'Pharmacy Name',
                hintText: 'ex: jon smith',
              ),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'ex: jon.smith@email.com',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _licenceNumberController,
                labelText: 'Licence Number',
                hintText: '123-456-789',
              ),
              _buildTextField(
                controller: _contactNumberController,
                labelText: 'Contact Number',
                hintText: '+92 300-1234567',
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _addressController,
                labelText: 'Address',
                hintText: '+92 300-1234567', // Using the second contact placeholder from the image
              ),

              // Terms and Policy Checkbox
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _agreedToTerms = newValue ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    const Text.rich(
                      TextSpan(
                        text: 'I Accept the ',
                        style: TextStyle(color: AppColors.text, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'terms & policy.',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // SIGN UP Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent, // Use a clear blue color as shown in the image
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'SIGN UP',
                        style: TextStyle(fontSize: 18, color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 20),
              
              // Social Sign-up Dividers
              const Center(child: Text('or sign up with', style: TextStyle(color: AppColors.text))),
              const SizedBox(height: 20),

              // Social Sign-up Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton('Google', Icons.g_mobiledata_rounded, Colors.red),
                  const SizedBox(width: 20),
                  _buildSocialButton('Facebook', Icons.facebook, Colors.blue),
                ],
              ),
              
              const SizedBox(height: 30),

              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have an account?', style: TextStyle(color: AppColors.text)),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.login);
                    },
                    child: const Text(
                      'SIGN IN',
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
}