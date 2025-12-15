// lib/features/home/views/searching_screen.dart

import 'package:flutter/material.dart';
import '../../../core/services/search_api_service.dart';
import '../../../routes/app_routes.dart';

class SearchingScreen extends StatefulWidget {
  final String medicineName;

  const SearchingScreen({super.key, required this.medicineName});

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  final SearchApiService _apiService = SearchApiService();
  
  static const double dummyLatitude = 31.5204; 
  static const double dummyLongitude = 74.3587; 

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  Future<void> _startSearch() async {
    try {
      final result = await _apiService.searchMedicine(
        medicineName: widget.medicineName,
        // FIX 20: Named parameter is 'latitude' as per corrected service definition
        latitude: dummyLatitude, 
        longitude: dummyLongitude,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.searchResults,
          arguments: result['data'],
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Search failed.')),
        );
        Navigator.pop(context); 
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Searching...')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('Looking for ${widget.medicineName} near you...',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}