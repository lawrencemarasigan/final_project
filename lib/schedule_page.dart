import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Map<String, String>> scheduleData = [
    {
      'surgeon': 'Dr. Smith',
      'patient': 'John Doe',
      'surgery': 'Appendectomy',
      'date': 'July 20, 2025',
      'time': '10:00 AM',
    },
    {
      'surgeon': 'Dr. Lopez',
      'patient': 'Jane Roe',
      'surgery': 'Gallbladder Removal',
      'date': 'July 21, 2025',
      'time': '2:00 PM',
    },
    {
      'surgeon': 'Dr. Tan',
      'patient': 'Michael Chan',
      'surgery': 'Heart Bypass',
      'date': 'July 22, 2025',
      'time': '8:00 AM',
    },
  ];

  void _addSurgerySchedule() {
    final _formKey = GlobalKey<FormState>();
    String surgeon = '', patient = '', surgery = '', date = '', time = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Surgery Schedule'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Surgeon'),
                  onSaved: (value) => surgeon = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Patient'),
                  onSaved: (value) => patient = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Surgery'),
                  onSaved: (value) => surgery = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Date'),
                  onSaved: (value) => date = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Time'),
                  onSaved: (value) => time = value ?? '',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  scheduleData.add({
                    'surgeon': surgeon,
                    'patient': patient,
                    'surgery': surgery,
                    'date': date,
                    'time': time,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🗓️ Surgery Schedule',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: scheduleData.length,
                itemBuilder: (context, index) {
                  final item = scheduleData[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.medical_services, color: Colors.green),
                      title: Text(
                        '${item['surgery']} for ${item['patient']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Surgeon: ${item['surgeon']}'),
                          Text('Date: ${item['date']}'),
                          Text('Time: ${item['time']}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSurgerySchedule,
        icon: const Icon(Icons.add),
        label: const Text('Add Schedule'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
