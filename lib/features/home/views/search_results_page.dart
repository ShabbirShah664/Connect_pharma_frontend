// lib/features/home/views/search_results_page.dart

import 'package:flutter/material.dart';
import '../../../data/models/search_result.dart'; 

class SearchResultsPage extends StatelessWidget {
  // FIX 6: Using 'results' as the named parameter to match AppRoutes.
  final List<SearchResult> results; 

  // FIX 6: Updated constructor
  const SearchResultsPage({super.key, required this.results}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: results.isEmpty
          ? const Center(child: Text('No results found.'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(result.pharmacyName),
                    subtitle: Text('${result.medicineName} available.'),
                    trailing: Text('${result.distance.toStringAsFixed(2)} km'),
                  ),
                );
              },
            ),
    );
  }
}
