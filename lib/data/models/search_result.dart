// lib/models/search_result.dart

class SearchResult {
  final String id;
  final String name;
  final String distance; // String because it's already formatted like "1.5" km
  final String stock;
  final bool isLimited;

  SearchResult({
    required this.id,
    required this.name,
    required this.distance,
    required this.stock,
    required this.isLimited,
  });

  // Factory constructor to create a SearchResult object from the JSON response
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      // Ensure data types match the backend's JSON structure (searchService.js)
      id: json['id'] as String,
      name: json['name'] as String,
      distance: json['distance'] as String,
      stock: json['stock'] as String,
      isLimited: json['isLimited'] as bool,
    );
  }

  // Helper method for display
  String get distanceDisplay => '$distance km';
}