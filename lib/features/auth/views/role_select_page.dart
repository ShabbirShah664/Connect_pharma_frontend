
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/route_constants.dart';

class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shield,
                  size: 100,
                  color: Colors.grey[200],
                ),
                 const Icon(
                  Icons.add,
                  size: 50,
                  color: Color(0xFF007BFF), // Primary Blue
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'CONNECT-PHARMA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BFF), // Primary Blue
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find Your Medicine Fast and Easy',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50),
            
            // "Login As :"
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Login As :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Role Buttons
            _buildRoleButton(context, 'User'),
            const SizedBox(height: 15),
            _buildRoleButton(context, 'Pharmacist'),
            const SizedBox(height: 15),
            _buildRoleButton(context, 'Driver'),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (role == 'Pharmacist') {
            Navigator.pushNamed(context, RouteConstants.pharmacyLogin);
          } else {
            Navigator.pushNamed(
              context, 
              RouteConstants.userLogin, 
              arguments: role
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007BFF), // Primary Blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          role,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}