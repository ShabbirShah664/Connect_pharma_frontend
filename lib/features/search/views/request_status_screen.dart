import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_constants.dart';
import '../../../../core/services/user_api_service.dart';
import '../../../../data/models/request_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class RequestStatusScreen extends StatefulWidget {
  const RequestStatusScreen({super.key});

  @override
  State<RequestStatusScreen> createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  List<dynamic> _responses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUpdatedStatus();
  }

  Future<void> _fetchUpdatedStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.AUTH_TOKEN_KEY);
      if (token == null) return;

      // 1. Get User's requests
      final requests = await UserApiService.fetchUserRequests(token);
      
      if (requests.isNotEmpty) {
        // 2. Get the latest request
        // NOTE: In a real app, we might pass the requestId to this screen
        final latestRequest = requests.first; 
        
        setState(() {
          _responses = latestRequest.responses ?? []; // Use the responses array from the model
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching responses: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Status'),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false, 
      ),
      body: Column(
        children: [
          // Header / Animation Area
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.lightBackground,
            child: Column(
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  'Waiting for pharmacists to respond...',
                  style: TextStyle(fontSize: 16, color: AppColors.lightText),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: _responses.length,
              itemBuilder: (context, index) {
                final response = _responses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.local_pharmacy, color: AppColors.primary),
                    title: Text(response['pharmacyName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (response['alternativeMedicine'] != null)
                           Text('Alternative: ${response['alternativeMedicine']}', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold))
                        else
                           const Text('Available Directly', style: TextStyle(color: Colors.green)),

                        Text('Distance: ${response['distance']}'),
                        Text('Note: ${response['note']}', style: const TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Implement Accept Logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Accepted offer from ${response['pharmacyName']}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                      child: const Text('Accept'),
                    ),
                  ),
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                 Navigator.pushReplacementNamed(context, AppRoutes.userHome);
              },
               style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text('Cancel Request'),
            ),
          )
        ],
      ),
    );
  }
}
