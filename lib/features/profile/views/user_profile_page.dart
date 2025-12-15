// lib/features/profile/views/user_profile_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_buttons.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Mock User Data
  String userName = "Syed Shabbir Hussain";
  String userEmail = "syed.shabbir@email.com";
  String userContact = "+92 300-1234567";

  // State for toggles (Mock)
  bool pushNotificationsEnabled = true;
  bool darkModeEnabled = false;
  bool soundEnabled = true;

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out? You will be taken back to the Intro Page.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: _handleLogout,
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    // --- AUTHENTICATION INTEGRATION POINT ---
    // 1. Clear local session (JWT token or user preferences).
    // 2. Clear state manager user data.
    print('User logged out. Clearing session data...');

    // Navigate to the Intro Page and remove all previous routes from the stack.
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.intro, (route) => false);
  }

  void _handleEditProfile() {
    // Placeholder for showing a dialog or navigating to an edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Profile functionality (Placeholder)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: const Icon(Icons.person, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(userEmail, style: TextStyle(fontSize: 16, color: AppColors.darkText.withOpacity(0.7))),
            const SizedBox(height: 5),
            Text(userContact, style: TextStyle(fontSize: 16, color: AppColors.darkText.withOpacity(0.7))),
            const SizedBox(height: 20),

            // Edit Button
            SecondaryTextButton(
              text: 'Edit Profile',
              onPressed: _handleEditProfile,
            ),
            const Divider(height: 30),

            // Profile Options
            _buildProfileOption(Icons.location_on, 'My Locations', () {}),
            _buildProfileOption(Icons.message, 'Messages', () {
              // Navigate to messages list
            }),
            _buildProfileOption(Icons.favorite, 'Favourite Pharmacies', () {}),
            _buildProfileOption(FontAwesomeIcons.fileMedical, 'Medical Records', () {
              // Navigation to records storage screen
            }),
            const Divider(height: 30),

            // Settings Toggles
            _buildSettingsToggle(
              Icons.notifications_active,
              'Push Notifications',
              pushNotificationsEnabled,
                  (val) => setState(() => pushNotificationsEnabled = val),
            ),
            _buildSettingsToggle(
              Icons.brightness_6,
              'Dark Mode',
              darkModeEnabled,
                  (val) => setState(() => darkModeEnabled = val),
            ),
            _buildSettingsToggle(
              Icons.volume_up,
              'Sound Effects',
              soundEnabled,
                  (val) => setState(() => soundEnabled = val),
            ),

            const Divider(height: 30),

            // Terms of Service Link
            _buildProfileOption(Icons.policy, 'Term of Service', () {}),

            const SizedBox(height: 40),

            // Logout Button
            PrimaryButton(
              text: 'LOGOUT',
              onPressed: _showLogoutConfirmation,
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSettingsToggle(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      onTap: () => onChanged(!value),
    );
  }
}