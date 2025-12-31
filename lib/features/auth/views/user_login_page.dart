
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/route_constants.dart';
import 'package:flutter_application_1/core/services/user_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/services/pharmacist_api_service.dart';
import 'package:flutter_application_1/data/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Instance for Pharmacist/Driver Service (assuming Driver follows similar pattern or same service)
  final PharmacistApiService _pharmacistApiService = PharmacistApiService();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  
  // Role will be set from arguments
  String _role = 'User'; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve role from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      _role = args;
    }
  }

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
      if (_role == 'User') {
        // 1. User Login
        final result = await UserApiService.loginUser(email, password);
        final user = UserModel.fromJson(Map<String, dynamic>.from(result['user']));
        final token = result['token'];

        // Save token for persistent auth
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', user.id);
        await prefs.setString('role', 'user');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${user.name}!')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.userHome, 
            (route) => false, 
            arguments: user,
          );
        }
      } else if (_role == 'Pharmacist') {
        // 2. Pharmacist Login
        final pharmacist = await _pharmacistApiService.loginPharmacist(email, password); 
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome, ${pharmacist.pharmacyName}!')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteConstants.pharmacistHome, 
            (route) => false, 
            arguments: pharmacist,
          );
        }
      } else {
        // 3. Driver Login (Assuming similar to Pharmacist for now or using User logic if not defined)
         // For now, let's assume Driver login is not fully implemented in the backend services I saw
         // OR it uses the same generic login endpoint if one existed.
         // Based on previous files, I only saw UserApiService and PharmacistApiService.
         // I'll stick to error/simulated for Driver or User flow if undefined.
         
         // Temporary Driver Handling:
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Driver login not fully implemented yet.')),
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
               const SizedBox(height: 10),
               // Logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.shield,
                      size: 80,
                      color: Colors.grey[200],
                    ),
                     const Icon(
                      Icons.add,
                      size: 40,
                      color: Color(0xFF007BFF), // Primary Blue
                    ),
                  ],
                ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 40),
              
              // Fields
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Login As: $_role', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),

              _buildTextField(
                controller: _emailController, 
                hintText: 'ex: jon.smith@gmail.com',
                labelText: 'Email'
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController, 
                hintText: '*********',
                labelText: 'Password',
                isPassword: true
              ),
              
              // Remember me
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe, 
                    activeColor: const Color(0xFF007BFF),
                    onChanged: (val) => setState(() => _rememberMe = val!),
                  ),
                  const Text('remember me'),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Log in', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 30),
              const Text('or sign in with', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              
              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google
                  _buildSocialButton(
                    icon: FontAwesomeIcons.google,
                    color: Colors.red,
                    onTap: () {},
                  ),
                  const SizedBox(width: 40), // Space between
                  // Facebook
                  _buildSocialButton(
                    icon: FontAwesomeIcons.facebookF,
                    color: Colors.blue,
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                       // Navigate to Signup, passing the current role potentially?
                       // The design creates separate signup page 'Signup user', 
                       // I'll stick to a generic logic or route to userSignUp
                       // If role is user, go to user signup.
                       if (_role == 'User') {
                          Navigator.pushNamed(context, RouteConstants.userSignup);
                       } else {
                          // Could have pharmacist signup
                          // Navigator.pushNamed(context, AppRoutes.pharmacistSignup);
                          // For now, default to User or show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signup for this role not implemented in this demo.')),
                          );
                       }
                    },
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
    required String hintText, 
    String? labelText,
    bool isPassword = false
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
            obscureText: isPassword && !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              suffixIcon: isPassword 
                ? IconButton(icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey), onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible)) 
                : null,
            ),
            validator: (value) {
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