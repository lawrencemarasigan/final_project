import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final List<Map<String, dynamic>> inventoryItems = [
    {'name': 'Hospital Bed', 'category': 'Furniture', 'quantity': 20},
    {'name': 'Wheelchair', 'category': 'Mobility', 'quantity': 15},
    {'name': 'Heart Monitor', 'category': 'Monitoring', 'quantity': 8},
    {'name': 'Defibrillator', 'category': 'Emergency', 'quantity': 5},
    {'name': 'Stethoscope', 'category': 'Diagnostic', 'quantity': 30},
    {'name': 'X-ray Machine', 'category': 'Imaging', 'quantity': 2},
    {'name': 'IV Bags', 'category': 'Support', 'quantity': 2},
    {'name': 'Surgical Gloves', 'category': 'Medical', 'quantity': 4},
    {'name': 'Face Masks', 'category': 'Respiratory', 'quantity': 5},
    {'name': 'Syringe', 'category': 'Medical', 'quantity': 1},
    {'name': 'Oxygen Tank', 'category': 'Respiratory', 'quantity': 12},
  ];

  void _addInventoryItem() {
    final _formKey = GlobalKey<FormState>();
    String name = '', category = '';
    int quantity = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Inventory Item'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  onSaved: (value) => name = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter item name' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  onSaved: (value) => category = value ?? '',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter category' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      quantity = int.tryParse(value ?? '0') ?? 0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    final parsed = int.tryParse(value);
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
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
                  inventoryItems.add({
                    'name': name,
                    'category': category,
                    'quantity': quantity,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Hospital Inventory',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inventoryItems.length,
              itemBuilder: (context, index) {
                final item = inventoryItems[index];
                final int quantity = item['quantity'];
                final bool isLowStock = quantity < 6;

                return Card(
                  color: isLowStock ? Colors.red.shade50 : null,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services),
                    title: Text(item['name']),
                    subtitle: Text('Category: ${item['category']}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Qty: $quantity',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (isLowStock)
                          const Text(
                            'Low Stock',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addInventoryItem,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
