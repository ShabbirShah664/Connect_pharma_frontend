import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/services/pharmacist_api_service.dart';
import '../../../routes/route_constants.dart';

class PharmacySignupPage extends StatefulWidget {
  const PharmacySignupPage({super.key});

  @override
  State<PharmacySignupPage> createState() => _PharmacySignupPageState();
}

class _PharmacySignupPageState extends State<PharmacySignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = PharmacistApiService();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenseController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _licenseController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms & policy.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        contactNumber: _contactController.text.trim(),
        licenseNumber: _licenseController.text.trim(),
        address: _addressController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pharmacy registered! Please login.')),
        );
        Navigator.pushReplacementNamed(context, RouteConstants.pharmacyLogin);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'CONNECT-PHARMA',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),
              ),
              const Text(
                'Find Your Medicine Fast and Easy',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              const Text(
                'Register Your Pharmacy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              _buildTextField(controller: _nameController, labelText: 'Pharmacy Name', hintText: 'ex: jon smith'),
              const SizedBox(height: 15),
              _buildTextField(controller: _emailController, labelText: 'Email', hintText: 'ex: jon.smith@gmail.com'),
              const SizedBox(height: 15),
              _buildTextField(controller: _licenseController, labelText: 'Licence Number', hintText: '123-456-789'),
              const SizedBox(height: 15),
              _buildTextField(controller: _contactController, labelText: 'Contact Number', hintText: '+92 300-1234567'),
              const SizedBox(height: 15),
              _buildTextField(controller: _addressController, labelText: 'Address', hintText: 'Address...'),
              const SizedBox(height: 15),
              _buildTextField(controller: _passwordController, labelText: 'Password', hintText: '*********', isPassword: true),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (v) => setState(() => _acceptTerms = v!),
                    activeColor: const Color(0xFF007BFF),
                  ),
                  const Text('I Accept the ', style: TextStyle(fontSize: 11)),
                  const Text('terms & policy.', style: TextStyle(fontSize: 11, color: Color(0xFF007BFF), fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SIGN UP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),

              const SizedBox(height: 25),
              const Text('or sign up with', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(FontAwesomeIcons.google, Colors.red, () {}),
                  const SizedBox(width: 40),
                  _buildSocialButton(FontAwesomeIcons.facebookF, Colors.blue, () {}),
                ],
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, RouteConstants.pharmacyLogin),
                    child: const Text('SIGN IN', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        child: FaIcon(icon, color: color, size: 20),
      ),
    );
  }
}
