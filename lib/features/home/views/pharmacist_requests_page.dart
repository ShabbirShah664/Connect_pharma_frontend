import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/pharmacist_api_service.dart';
import '../../../data/models/request_model.dart';
import '../../../theme/app_colors.dart';

class PharmacistRequestsPage extends StatefulWidget {
  const PharmacistRequestsPage({super.key});

  @override
  State<PharmacistRequestsPage> createState() => _PharmacistRequestsPageState();
}

class _PharmacistRequestsPageState extends State<PharmacistRequestsPage> {
  bool _isLoading = true;
  List<RequestModel> _requests = [];
  String? _token;
  String? _pharmacyName;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Start polling for real-time updates every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchRequests(isSilent: true));
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _pharmacyName = prefs.getString('pharmacyName') ?? 'My Pharmacy';
    
    if (_token != null) {
      _fetchRequests();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchRequests({bool isSilent = false}) async {
    if (!isSilent) setState(() => _isLoading = true);
    try {
      final requests = await PharmacistApiService.getPendingRequests(_token!);
      if (mounted) {
        setState(() {
          _requests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!isSilent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      if (mounted && !isSilent) setState(() => _isLoading = false);
    }
  }

  Future<void> _respond(String requestId, String status, {String? suggestion}) async {
    try {
      // Mock location for demo purposes (In a real app, use geolocator)
      final location = {'latitude': 24.8607, 'longitude': 67.0011}; 

      await PharmacistApiService.respondToRequest(
        token: _token!,
        requestId: requestId,
        status: status,
        pharmacyName: _pharmacyName!,
        location: location,
        suggestedMedicine: suggestion,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(status == 'AVAILABLE' ? 'Offer sent to user!' : 'Request ignored.')),
        );
        // Remove from list
        setState(() {
          _requests.removeWhere((r) => r.id == requestId);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to respond: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Recently Requested', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _requests.isEmpty 
          ? const Center(child: Text('No active requests in your area.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                return _buildRequestCard(request);
              },
            ),
    );
  }

  Widget _buildRequestCard(RequestModel request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Patient Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(request.medicineName, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)),
                child: const Text('New Request', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text('Within ${request.radius}Km', style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => _respond(request.id, 'AVAILABLE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Available', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => _respond(request.id, 'NOT_AVAILABLE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC3545),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Not Available', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.center,
            child: Text('Not Available? Suggest any alternative', style: TextStyle(color: Colors.grey, fontSize: 11)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                 // Open a dialog to suggest alternative
                 _showSuggestDialog(request.id);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF28A745)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Suggest', style: TextStyle(color: Color(0xFF28A745), fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuggestDialog(String requestId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggest Alternative'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter medicine name...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _respond(requestId, 'AVAILABLE', suggestion: controller.text.trim());
            }, 
            child: const Text('Send')
          ),
        ],
      ),
    );
  }
}
