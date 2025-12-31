import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/route_constants.dart';

class PharmacistHomePage extends StatelessWidget {
  const PharmacistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pharmacist Dashboard', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, RouteConstants.intro, (r) => false);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildActionCard(
              context,
              title: 'View Requests',
              icon: Icons.list_alt_rounded,
              color: const Color(0xFF007BFF),
              onTap: () => Navigator.pushNamed(context, RouteConstants.pharmacistRequests),
            ),
            const SizedBox(height: 20),
            _buildActionCard(
              context,
              title: 'Chats',
              icon: Icons.chat_bubble_outline_rounded,
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, RouteConstants.pharmacistChats),
            ),
            const SizedBox(height: 20),
            _buildActionCard(
              context,
              title: 'View Orders',
              icon: Icons.shopping_basket_outlined,
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, RouteConstants.pharmacistOrders),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, spreadRadius: 5),
          ],
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
