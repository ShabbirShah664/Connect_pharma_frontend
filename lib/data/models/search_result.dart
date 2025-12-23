class SearchResult {
  final String pharmacyId;
  final String pharmacyName;
  final String medicineName;
  final double distance;

  SearchResult({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.medicineName,
    required this.distance,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      pharmacyId: json['pharmacyId'] ?? '',
      pharmacyName: json['pharmacyName'] ?? 'Unknown Pharmacy',
      medicineName: json['medicineName'] ?? 'Medicine',
      // Safely convert distance to double even if it comes as int
      distance: (json['distance'] as num).toDouble(),
    );
  }
}