
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/route_constants.dart';
import 'package:flutter_application_1/core/services/user_api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({super.key});

  @override
  State<UserSignupPage> createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _contactController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms & policy.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Construct user data
    // Note: Ensuring API service accepts contactNumber
    final userData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'contactNumber': _contactController.text.trim(),
    };

    try {
      await UserApiService.registerUser(
        userData['name']!,
        userData['email']!,
        userData['password']!,
        userData['contactNumber']!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully! Please login.')),
        );
        // Navigate to Login (User role)
        Navigator.of(context).pushReplacementNamed(
          RouteConstants.userLogin,
          arguments: 'User'
        );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const SizedBox(height: 0),
              const Text(
                'CONNECT-PHARMA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007BFF),
                ),
              ),
               const SizedBox(height: 5),
              const Text(
                'Find Your Medicine Fast and Easy',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              
              const Text('Create your Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Fields
              _buildTextField(
                controller: _nameController, 
                hintText: 'ex: jon smith', 
                labelText: 'Name'
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _emailController, 
                hintText: 'ex: jon.smith@gmail.com', 
                labelText: 'Email',
                inputType: TextInputType.emailAddress
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController, 
                hintText: '*********', 
                labelText: 'Password',
                isPassword: true
              ),
               const SizedBox(height: 15),
              _buildTextField(
                controller: _confirmPasswordController, 
                hintText: '*********', 
                labelText: 'Confirm password',
                isPassword: true,
                validator: (val) {
                  if (val != _passwordController.text) return 'Passwords do not match';
                  return null;
                }
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _contactController, 
                hintText: '+62 300-1234567', 
                labelText: 'Contact Number',
                inputType: TextInputType.phone
              ),
              
              const SizedBox(height: 20),
              
              // Terms Checkbox (Simulated centered layout with checkbox)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _acceptTerms, 
                    activeColor: const Color(0xFF007BFF),
                    onChanged: (val) => setState(() => _acceptTerms = val!),
                  ),
                  const Text('I Accept the ', style: TextStyle(fontSize: 12)),
                  const Text('terms & policy.', style: TextStyle(fontSize: 12, color: Color(0xFF007BFF), fontWeight: FontWeight.bold)),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('SIGN UP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 30),
              const Text('or sign up with', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              
              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(
                    icon: FontAwesomeIcons.google,
                    color: Colors.red, // Google Red
                    onTap: () {},
                  ),
                  const SizedBox(width: 40),
                  _buildSocialButton(
                    icon: FontAwesomeIcons.facebookF,
                    color: Colors.blue, // FB Blue
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                       // Navigate to login
                       Navigator.of(context).pushReplacementNamed(
                         RouteConstants.userLogin, 
                         arguments: 'User'
                       );
                    },
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
    required String hintText, 
    String? labelText,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && isPassword ? (labelText == 'Confirm password' ? !_isConfirmPasswordVisible : !_isPasswordVisible) : false,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              suffixIcon: isPassword 
                ? IconButton(
                    icon: Icon(
                      (labelText == 'Confirm password' ? _isConfirmPasswordVisible : _isPasswordVisible) 
                      ? Icons.visibility : Icons.visibility_off, 
                      color: Colors.grey
                    ), 
                    onPressed: () {
                      setState(() {
                        if (labelText == 'Confirm password') {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        } else {
                          _isPasswordVisible = !_isPasswordVisible;
                        }
                      });
                    }
                  ) 
                : null,
            ),
            validator: validator ?? (value) {
              if (value == null || value.isEmpty) return 'Required';
              return null;
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildSocialButton({required IconData icon, required Color color, required VoidCallback onTap}) {
     return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }
}