// lib/features/home/views/user_home_page.dart

import 'package:flutter/material.dart';
import '../../../widgets/custom_form_fields.dart' as CustomWidgets; // FIX
// ... (rest of imports)

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final TextEditingController _searchController = TextEditingController();

  // Placeholder for search logic
  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      // Assuming you navigate to the searching screen
      Navigator.pushNamed(
        context,
        '/searching', // Use the actual route constant if defined
        arguments: {'medicineName': _searchController.text},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome!', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 30),
              
              // FIX 24: Use CustomWidgets prefix
              CustomWidgets.CustomTextField( 
                controller: _searchController,
                labelText: 'Search Medicine',
                icon: Icons.search,
                readOnly: true, // Typically readOnly for a tap-to-search interface
                onTap: () {
                  // Allow tap to search or navigate to a dedicated search page
                  _performSearch();
                },
              ),
              const SizedBox(height: 20),
              
              // FIX 25: Use CustomWidgets prefix
              CustomWidgets.CustomButton( 
                text: 'Locate Pharmacies',
                onPressed: _performSearch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}