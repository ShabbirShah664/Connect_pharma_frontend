import 'package:flutter/material.dart';

class MedicineAlarmPage extends StatefulWidget {
  const MedicineAlarmPage({super.key});

  @override
  State<MedicineAlarmPage> createState() => _MedicineAlarmPageState();
}

class _MedicineAlarmPageState extends State<MedicineAlarmPage> {
  final List<Map<String, dynamic>> _alarms = [
    {'name': 'Panadol', 'time': '08:00 AM', 'days': 'Mon, Wed, Fri', 'isActive': true},
    {'name': 'Amoxicillin', 'time': '02:00 PM', 'days': 'Daily', 'isActive': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Medicine Reminders', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _alarms.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _alarms.length,
            itemBuilder: (context, index) {
              final alarm = _alarms[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007BFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.alarm, color: Color(0xFF007BFF)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alarm['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('${alarm['time']} • ${alarm['days']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Switch(
                        value: alarm['isActive'],
                        onChanged: (val) {
                          setState(() => alarm['isActive'] = val);
                        },
                        activeColor: const Color(0xFF007BFF),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add alarm logic
        },
        backgroundColor: const Color(0xFF007BFF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text('No reminders set', style: TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(height: 10),
          const Text('Click + to add a medicine alarm', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
