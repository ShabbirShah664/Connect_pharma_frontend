import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_constants.dart';
import '../../../../core/services/pharmacist_api_service.dart';
import '../../../../data/models/request_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../routes/app_routes.dart';

class PharmacistDashboard extends StatefulWidget {
  const PharmacistDashboard({super.key});

  @override
  State<PharmacistDashboard> createState() => _PharmacistDashboardState();
}

class _PharmacistDashboardState extends State<PharmacistDashboard> {
  List<RequestModel> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.AUTH_TOKEN_KEY);
      if (token == null) return;

      final requests = await PharmacistApiService.getPendingRequests(token);
      if (mounted) {
        setState(() {
          _pendingRequests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching pending requests: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Dashboard'),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               setState(() => _isLoading = true);
               _fetchRequests();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.intro);
            },
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Pending Requests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _pendingRequests.isEmpty 
              ? const Center(child: Text("No pending requests nearby."))
              : ListView.builder(
              itemCount: _pendingRequests.length,
              itemBuilder: (context, index) {
                final request = _pendingRequests[index];
                // Handle medicineDetails safely
                final medicineName = request.medicineDetails['name']?.toString() ?? 'Unknown Medicine';
                final address = request.deliveryLocation['address']?.toString() ?? 'Location N/A';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.lightBackground,
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    title: Text(request.userName ?? 'User'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Needs: $medicineName', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Location: $address'),
                        const Text('Tap to respond', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        AppRoutes.requestDetails, 
                        // Convert to Map for screen compatibility
                        arguments: request.toJson()
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
