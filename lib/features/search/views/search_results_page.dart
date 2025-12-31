// lib/features/search/views/search_results_page.dart

import 'package:flutter/material.dart';
import '../../../routes/route_constants.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_buttons.dart';
import '../../../features/chat/views/chat_screen.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  // Mock data for search results
  final List<Map<String, dynamic>> mockResults = const [
    {'name': 'Life-Care Pharmacy', 'distance': '2km', 'stock': 'Available', 'limited': true},
    {'name': 'Curex', 'distance': '2km', 'stock': 'Not Available', 'limited': false},
    {'name': 'Lahore Care Pharmacy', 'distance': '5km', 'stock': 'Available', 'limited': false},
    {'name': 'Amoxicilin Pharmacy', 'distance': '5km', 'stock': 'Not Available', 'limited': false, 'ai_approved': true},
    {'name': 'City Pharmacy', 'distance': '10km', 'stock': 'Available', 'limited': true},
  ];

  void _handleAskForSuggestions(BuildContext context) {
    // --- AI INTEGRATION POINT ---
    // This is the fallback action after 10km search fails.
    // Call the Node.js API endpoint: /ai/suggest
    print('Triggering AI module for alternative suggestions...');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Suggestions Triggered'),
        content: const Text(
          'No exact match was found. The AI module is now generating alternatives for you.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter to show only 'Available' results for the main list
    final availableResults = mockResults.where((r) => r['stock'] == 'Available').toList();
    final noResults = availableResults.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results / Response Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: noResults
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'No pharmacy has responded YES yet (within 10km radius). Please try "Ask for Suggestions".',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: AppColors.darkText),
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: availableResults.length,
              itemBuilder: (context, index) {
                final result = availableResults[index];
                return _PharmacyResultCard(
                  name: result['name'],
                  distance: result['distance'],
                  isLimited: result['limited'],
                  onContact: () {
                    // Pass pharmacy name to chat screen
                    // Navigator.pushNamed(context, '/chat', arguments: {'pharmacistName': result['name']});
                  },
                  onDeliver: () {
                    // Placeholder for initiating delivery
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delivery initiated for ${result['name']}')),
                    );
                  },
                );
              },
            ),
          ),

          // Ask for Suggestions Button (Always visible as fallback)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: PrimaryButton(
              text: 'Ask For Suggestions',
              onPressed: () => _handleAskForSuggestions(context),
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _PharmacyResultCard extends StatelessWidget {
  final String name;
  final String distance;
  final bool isLimited;
  final VoidCallback onContact;
  final VoidCallback onDeliver;

  const _PharmacyResultCard({
    required this.name,
    required this.distance,
    required this.isLimited,
    required this.onContact,
    required this.onDeliver,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_pharmacy, color: AppColors.primary),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Within $distance',
                  style: TextStyle(color: AppColors.darkText.withOpacity(0.7)),
                ),
                const Spacer(),
                if (isLimited)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('Limited Stock', style: TextStyle(color: AppColors.darkText, fontSize: 12)),
                  ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text('Available YES', style: TextStyle(color: AppColors.lightText, fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: onContact,
                  icon: const Icon(Icons.chat, size: 20),
                  label: const Text('Contact'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onDeliver,
                  icon: const Icon(Icons.local_shipping, size: 20),
                  label: const Text('Deliver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.lightText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
