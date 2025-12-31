import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/services/pharmacist_api_service.dart';
import '../../../routes/route_constants.dart';

class PharmacyLoginPage extends StatefulWidget {
  const PharmacyLoginPage({super.key});

  @override
  State<PharmacyLoginPage> createState() => _PharmacyLoginPageState();
}

class _PharmacyLoginPageState extends State<PharmacyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final PharmacistApiService _apiService = PharmacistApiService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final pharmacist = await _apiService.login(_emailController.text.trim(), _passwordController.text);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', pharmacist.token ?? ''); // Assuming token is in pharmacist object
      await prefs.setString('role', 'pharmacist');
      await prefs.setString('pharmacyId', pharmacist.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${pharmacist.pharmacyName}!')),
        );
        Navigator.pushNamedAndRemoveUntil(context, RouteConstants.pharmacistHome, (r) => false);
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
              const SizedBox(height: 10),
              // Logo Section
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.shield, size: 100, color: Colors.grey[100]),
                  const Icon(Icons.add, size: 50, color: Color(0xFF007BFF)),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'CONNECT-PHARMA',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF007BFF)),
              ),
              const Text(
                'Find Your Medicine Fast and Easy',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Fields
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'ex: jon.smith@gmail.com',
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: '*********',
                isPassword: true,
              ),

              // Remember Me
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v!),
                    activeColor: const Color(0xFF007BFF),
                  ),
                  const Text('Remember Me', style: TextStyle(fontSize: 12)),
                ],
              ),

              const SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Log in', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 30),
              const Text('or sign in with', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),

              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(FontAwesomeIcons.google, Colors.red, () {}),
                  const SizedBox(width: 40),
                  _buildSocialButton(FontAwesomeIcons.facebookF, Colors.blue, () {}),
                ],
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, RouteConstants.pharmacySignup),
                    child: const Text('SIGN UP', style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold)),
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
        Text(labelText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              suffixIcon: isPassword 
                ? IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ) 
                : null,
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
