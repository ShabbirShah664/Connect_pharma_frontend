import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/search_result.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query, required List<SearchResult> results});

  @override
  Widget build(BuildContext context) {
    // This is a placeholder. Usually, you'd use a FutureBuilder here 
    // to call SearchService.searchPharmacies(query)
    return Scaffold(
      appBar: AppBar(title: Text('Results for "$query"')),
      body: const Center(
        child: Text('Search results logic goes here'),
      ),
    );
  }
}