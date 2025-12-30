// lib/features/search/views/searching_screen.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../widgets/custom_form_fields.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  final TextEditingController _medicineController = TextEditingController();
  String _currentLocation = 'Fetching location...'; // Placeholder

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  // Placeholder for Location Logic
  void _fetchUserLocation() async {
    // --- LOCATION INTEGRATION POINT ---
    // 1. Request device location permission.
    // 2. Use a package (like geolocator) to get the latitude and longitude.
    // 3. Use Google Maps API (geocoding) to convert coordinates to a readable address.
    await Future.delayed(const Duration(seconds: 2)); // Simulate fetching delay
    setState(() {
      _currentLocation = 'Lahore, Pakistan (Auto-Detected)';
    });
  }

  void _handleFindMedicine() async {
    bool isMedicineNameEntered = _medicineController.text.trim().isNotEmpty;

    if (!isMedicineNameEntered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a medicine name.')),
      );
      return;
    }

    // Mocking Image Upload for now
    String? mockImageUrl; 
    
    try {
      // 1. Get Token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.AUTH_TOKEN_KEY); 

      if (token == null) {
        throw Exception('User authentication error. Please login again.');
      }

      // 2. Prepare Data
      final requestData = {
        'medicineDetails': {
          'name': _medicineController.text.trim(),
          'description': 'User request from app',
        },
        'deliveryLocation': {
          'address': _currentLocation,
          'lat': 31.5204, // Mock coordinates for Lahore
          'lng': 74.3587,
        },
        'preferredTime': 'ASAP',
        'prescriptionImageUrl': mockImageUrl, 
      };

      // 3. Call API
      await UserApiService.submitMedicineRequest(token, requestData);

      if (mounted) {
        // 4. Navigate to Status Screen (Indrive-style waiting)
        // We will create this screen next. For now, using a placeholder navigation.
        Navigator.pushNamed(context, AppRoutes.requestStatus); 
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide back button on the home screen
        title: const Text('Connect-Pharma Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.lightText),
            onPressed: () {
              // Placeholder for notifications screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Bar
            // Search Bar
            TextFormField(
              controller: _medicineController,
              decoration: InputDecoration(
                labelText: 'Type Medicine Name',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: AppColors.text), // Ensure text is visible
            ),
            const SizedBox(height: 30),

            // Upload Prescription Button
            PrimaryButton(
              text: 'Upload Prescription (Image/PDF/Word)',
              onPressed: () {
                // --- FILE UPLOAD INTEGRATION POINT ---
                // Implement file picker logic (e.g., file_picker package)
                print('Opening file picker for prescription...');
              },
              color: AppColors.secondary,
            ),
            const SizedBox(height: 30),

            // Location Section
            const Text(
              'Your Location:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _currentLocation,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SecondaryTextButton(
                    text: 'Edit/Manual',
                    onPressed: () {
                      // Placeholder for manual location input dialog
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Find Button
            PrimaryButton(
              text: 'FIND MEDICINE',
              onPressed: _handleFindMedicine,
            ),
            const SizedBox(height: 30),

            // Placeholder for AI Suggestion Button as per the Figma/request
            PrimaryButton(
              text: 'Ask For Suggestions (AI)',
              onPressed: () {
                // --- AI INTEGRATION POINT ---
                // This typically runs when search fails, but can be a direct link too.
                print('Directly asking for AI suggestions...');
              },
              color: AppColors.accent,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}

// Reusable Bottom Navigation Bar for User Flow
Widget _buildBottomNavBar(BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.darkText.withOpacity(0.6),
    currentIndex: 0, // Currently on Home
    onTap: (index) {
      if (index == 0) return; // Already on Home
      if (index == 3) {
        Navigator.pushNamed(context, AppRoutes.userProfile);
      }
      // Implement navigation for Tracker (1) and AI (2) when screens exist
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Tracker'),
      BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.brain), label: 'AI'),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
    ],
  );
}
