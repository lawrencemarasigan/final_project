import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final List<Map<String, String>> users = [];
  String searchQuery = '';

  void showAddUserDialog() {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final username = usernameController.text.trim();
              final password = passwordController.text.trim();
              if (username.isNotEmpty && password.isNotEmpty) {
                setState(() {
                  users.add({
                    'username': username,
                    'password': password,
                    'availability': 'Available'
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void removeUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  void showEditAvailabilityDialog(int index) {
    String selectedAvailability = users[index]['availability'] ?? 'Available';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Availability'),
        content: DropdownButtonFormField<String>(
          value: selectedAvailability,
          items: const [
            DropdownMenuItem(value: 'Available', child: Text('Available')),
            DropdownMenuItem(value: 'In Surgery', child: Text('In Surgery')),
            DropdownMenuItem(value: 'On Leave', child: Text('On Leave')),
            DropdownMenuItem(value: 'Unavailable', child: Text('Unavailable')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                users[index]['availability'] = value;
              });
            }
          },
          decoration: const InputDecoration(labelText: 'Availability'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> get filteredUsers {
    if (searchQuery.isEmpty) return users;
    return users
        .where((user) => user['username']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> displayedUsers = filteredUsers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'User Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search Users',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Users:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: displayedUsers.isEmpty
              ? const Center(child: Text('No users found.'))
              : ListView.builder(
                  itemCount: displayedUsers.length,
                  itemBuilder: (context, index) {
                    final actualIndex =
                        users.indexOf(displayedUsers[index]);
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                            'Username: ${displayedUsers[index]['username']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password: ${displayedUsers[index]['password']}'),
                            Text('Availability: ${displayedUsers[index]['availability'] ?? 'Unknown'}'),
                          ],
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  showEditAvailabilityDialog(actualIndex),
                              tooltip: 'Edit Availability',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeUser(actualIndex),
                              tooltip: 'Delete User',
                            ),
                          ],
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
            onPressed: showAddUserDialog,
            icon: const Icon(Icons.person_add),
            label: const Text('Add User'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
