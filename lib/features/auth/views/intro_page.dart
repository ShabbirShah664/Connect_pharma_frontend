// lib/features/auth/views/intro_page.dart
import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.health_and_safety,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Connect-Pharma',
              // Use titleLarge as headlineLarge might not be available or may require custom style
              style: Theme.of(context).textTheme.titleLarge?.copyWith( 
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your quick link to nearby medicines.',
              style: TextStyle(fontSize: 18, color: AppColors.text),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigate to Role Selection Page
                Navigator.pushNamed(context, AppRoutes.roleSelection);
              },
              style: ElevatedButton.styleFrom(
                // FIX: Changed AppColors.accent to AppColors.secondary
                backgroundColor: AppColors.secondary, 
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Get Started', style: TextStyle(fontSize: 18, color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}