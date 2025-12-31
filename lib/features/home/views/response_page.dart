
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/user_api_service.dart';
import '../../../routes/route_constants.dart';
import '../../../widgets/user_bottom_nav.dart';

class ResponsePage extends StatefulWidget {
  final String requestId;
  const ResponsePage({super.key, required this.requestId});

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  Timer? _timer;
  bool _isLoading = true;
  List<Map<String, dynamic>> _responses = [];
  int _currentRadius = 5;
  String _status = 'SEARCHING';
  int _expandedIndex = -1;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initTokenAndStartPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initTokenAndStartPolling() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    
    if (_token != null) {
      _startPolling();
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication error. Please login again.')),
        );
      }
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchRequestStatus();
    });
    _fetchRequestStatus();
  }

  Future<void> _fetchRequestStatus() async {
    if (_token == null) return;
    try {
      final data = await UserApiService.getRequestStatus(_token!, widget.requestId);
      if (mounted) {
        setState(() {
          _status = data['status'];
          _currentRadius = data['radius'] ?? 5;
          _responses = List<Map<String, dynamic>>.from(data['responses'] ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error polling: $e");
    }
  }

  Future<void> _expandRadius() async {
    if (_token == null) return;
    setState(() => _isLoading = true);
    try {
      await UserApiService.expandRequestRadius(_token!, widget.requestId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error expanding radius: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('CONNECT-PHARMA', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: const Text('SearchResults', 
              style: TextStyle(color: Color(0xFF007BFF), fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          
          Expanded(
            child: _isLoading && _responses.isEmpty 
              ? const Center(child: CircularProgressIndicator()) 
              : _responses.isEmpty 
                ? _buildEmptyView()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: _responses.length,
                    itemBuilder: (context, index) {
                      return _buildPharmacyCard(index, _responses[index]);
                    },
                  ),
          ),
          
          // Bottom Action
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Ask AI For Suggestions', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: UserBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) Navigator.pushNamedAndRemoveUntil(context, RouteConstants.userHome, (r) => false);
          if (index == 1) Navigator.pushNamed(context, RouteConstants.medicineAlarms);
          if (index == 2) Navigator.pushNamed(context, RouteConstants.userProfile);
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 20),
          Text('Searching in ${_currentRadius}km radius...', style: const TextStyle(color: Colors.grey)),
          if (_currentRadius < 15)
            TextButton(
              onPressed: _expandRadius,
              child: const Text('Expand Search Radius'),
            )
        ],
      ),
    );
  }

  Widget _buildPharmacyCard(int index, Map<String, dynamic> data) {
    if (data['status'] != 'AVAILABLE') return const SizedBox.shrink();

    bool isExpanded = _expandedIndex == index;
    final location = data['location'] ?? {};
    final lat = location['latitude'] ?? 0.0;
    final lng = location['longitude'] ?? 0.0;
    final suggestion = data['suggestedMedicine'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedIndex = isExpanded ? -1 : index;
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF007BFF).withOpacity(0.1),
                    radius: 20,
                    child: const Icon(Icons.local_pharmacy, color: Color(0xFF007BFF)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['pharmacyName'] ?? 'Pharmacy', 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Available',
                                style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            Text('Location: $lat, $lng', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
              
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 52),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (suggestion != null) ...[
                         Row(
                           children: [
                             const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                             const SizedBox(width: 8),
                             const Text('Alternative Suggested:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                           ],
                         ),
                         Text(suggestion, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                         const SizedBox(height: 12),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Chat starting...'))
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Contact', style: TextStyle(color: Colors.black87, fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Opening Maps...'))
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF007BFF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: const Text('View on Map', style: TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

