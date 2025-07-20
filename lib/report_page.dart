import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final List<Map<String, String>> surgeryList = [
    {
      'patient': 'John Doe',
      'surgeon': 'Dr. Smith',
      'date': '2025-07-17',
      'status': 'Completed',
    },
    {
      'patient': 'Jane Roe',
      'surgeon': 'Dr. Adams',
      'date': '2025-07-18',
      'status': 'Scheduled',
    },
    {
      'patient': 'Mary Johnson',
      'surgeon': 'Dr. Taylor',
      'date': '2025-07-17',
      'status': 'In Progress',
    },
  ];

  void showAddSurgeryDialog() {
    final patientController = TextEditingController();
    final surgeonController = TextEditingController();
    final dateController = TextEditingController();
    String selectedStatus = 'Scheduled';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Surgery Report'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: patientController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
              ),
              TextField(
                controller: surgeonController,
                decoration: const InputDecoration(labelText: 'Surgeon Name'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'Scheduled', child: Text('Scheduled')),
                  DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                  DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final patient = patientController.text.trim();
              final surgeon = surgeonController.text.trim();
              final date = dateController.text.trim();

              if (patient.isNotEmpty &&
                  surgeon.isNotEmpty &&
                  date.isNotEmpty) {
                setState(() {
                  surgeryList.add({
                    'patient': patient,
                    'surgeon': surgeon,
                    'date': date,
                    'status': selectedStatus,
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = Colors.green;
        break;
      case 'In Progress':
        color = Colors.orange;
        break;
      case 'Scheduled':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // Light grey to match dashboard
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Surgery Reports',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: surgeryList.isEmpty
                ? const Center(child: Text('No surgeries available.'))
                : ListView.builder(
                    itemCount: surgeryList.length,
                    itemBuilder: (context, index) {
                      final surgery = surgeryList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ListTile(
                            leading: const Icon(Icons.local_hospital, color: Colors.teal),
                            title: Text('Patient: ${surgery['patient']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Surgeon: ${surgery['surgeon']}'),
                                Text('Date: ${surgery['date']}'),
                              ],
                            ),
                            trailing: _buildStatusBadge(surgery['status']!),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: showAddSurgeryDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Surgery Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
