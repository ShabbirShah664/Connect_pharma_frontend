import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_constants.dart';
import '../../../../core/services/pharmacist_api_service.dart';
import '../../../../theme/app_colors.dart';

class RequestDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> requestData;

  const RequestDetailsScreen({super.key, required this.requestData});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  bool _available = true;

  @override
  Widget build(BuildContext context) {
    final request = widget.requestData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Respond to Request'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request['userName'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(request['location'] ?? 'Location N/A', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const Divider(height: 30),
            
            // Medicine Request Details
            const Text('Requested Medicine:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(request['medicineName'] ?? 'N/A', style: const TextStyle(fontSize: 22, color: AppColors.primary)),
            
            const SizedBox(height: 20),
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Center(child: Text('Prescription Image Placeholder\n(Normally loaded from URL)', textAlign: TextAlign.center)),
            ),
            const SizedBox(height: 30),

            // Pharmacist Response Form
            const Text('Your Offer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            Row(
              children: [
                const Text('Available?'),
                Switch(
                  value: _available,
                  onChanged: (val) => setState(() => _available = val),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            
            if (_available) ...[
              const Text('Great! You have the medicine.', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ] else ...[
               TextFormField(
                controller: _priceController, // Re-using controller name for simplicity, but logically it's alternative
                decoration: const InputDecoration(
                  labelText: 'Suggest Alternative (Optional)',
                  prefixIcon: Icon(Icons.medication),
                  hintText: 'e.g., Panadol -> Calpol'
                ),
              ),
            ],
            
            const SizedBox(height: 10),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note to User',
                hintText: 'e.g., Same formula, different brand',
              ),
            ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString(ApiConstants.AUTH_TOKEN_KEY);
                      
                      if (token == null) throw Exception('Not authenticated');

                      await PharmacistApiService.respondToRequest(
                        token,
                        request['id'],
                        _available ? 'available' : 'unavailable',
                        _available ? null : _priceController.text, // alternative med
                        _noteController.text,
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Response Sent Successfully!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      if (!mounted) return;
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Send Response', style: TextStyle(fontSize: 16)),
                ),
                ),
            
          ],
        ),
      ),
    );
  }
}
