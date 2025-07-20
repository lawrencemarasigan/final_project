import 'package:flutter/material.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = [
      'User admin logged in.',
      'Inventory updated: IV Bags.',
      'Scheduled surgery for patient #123.',
      'Report generated for June.',
      'User admin logged out.',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const Icon(Icons.event_note),
          title: Text(logs[index]),
        ),
      ),
    );
  }
}