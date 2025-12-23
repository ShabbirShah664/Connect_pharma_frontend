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

  void _handleFindMedicine() {
    // --- VALIDATION LOGIC ---
    // The request can be generated with Medicine Name OR uploaded Prescription
    bool isMedicineNameEntered = _medicineController.text.trim().isNotEmpty;
    bool isPrescriptionUploaded = false; // Mocking a check for now

    if (!isMedicineNameEntered && !isPrescriptionUploaded) {
      // Show Alert Box
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Empty Fields'),
          content: const Text(
            'The entry fields are empty. Please enter a medicine name or upload a prescription.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
      return;
    }

    // --- SEARCH LOGIC INTEGRATION POINT ---
    // 1. Display a loading screen or animation (Indrive-style waiting).
    // 2. Send the request to Node.js backend: /search/medicine.
    // 3. The backend handles the 2km -> 5km -> 10km radius expansion and notifies pharmacists.
    // 4. Once responses start coming in, navigate to the search results page.
    print('Search initiated for: ${_medicineController.text} at $_currentLocation');

    // Placeholder: Navigate to results page instantly with mock data
    Navigator.pushNamed(context, AppRoutes.searchResults);
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
            CustomTextField(
              labelText: 'Type Medicine Name',
              controller: _medicineController,
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
