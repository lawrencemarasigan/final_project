import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'user_page.dart';
import 'inventory_page.dart';
import 'schedule_page.dart';
import 'report_page.dart';
import 'logs_page.dart';

class DashboardPage extends StatefulWidget {
  final String username;

  const DashboardPage({super.key, required this.username});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String currentPage = 'Dashboard';
  String selectedFilter = 'Today';

  final List<Map<String, dynamic>> lowStockItems = const [
    {'name': 'Surgical Gloves', 'quantity': 4},
    {'name': 'IV Bags', 'quantity': 2},
    {'name': 'Face Masks', 'quantity': 5},
    {'name': 'Syringes', 'quantity': 1},
    {'name': 'Defibrillator', 'quantity': 1},
  ];

  final List<DateTime> successfulSurgeries = [
    ...List.generate(10, (_) => DateTime.now()),
    ...List.generate(44, (i) => DateTime.now().subtract(Duration(days: i + 1))),
    ...List.generate(243, (i) => DateTime.now().subtract(Duration(days: i + 31))),
  ];

  void selectPage(String page) {
    setState(() {
      currentPage = page;
    });
    Navigator.pop(context);
  }

  int getFilteredSurgeryCount() {
    final now = DateTime.now();
    return successfulSurgeries.where((date) {
      if (selectedFilter == 'Today') {
        return date.year == now.year && date.month == now.month && date.day == now.day;
      } else if (selectedFilter == 'This Month') {
        return date.year == now.year && date.month == now.month && date.day <= 15;
      } else if (selectedFilter == 'This Year') {
        return date.year == now.year;
      }
      return false;
    }).length;
  }

  List<BarChartGroupData> _generateBarData() {
    final now = DateTime.now();
    Map<int, int> groupedData = {};

    if (selectedFilter == 'Today') {
      for (var date in successfulSurgeries) {
        if (date.year == now.year && date.month == now.month && date.day == now.day) {
          groupedData.update(date.hour, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    } else if (selectedFilter == 'This Month') {
      for (var date in successfulSurgeries) {
        if (date.year == now.year && date.month == now.month && date.day <= 15) {
          groupedData.update(date.day, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    } else if (selectedFilter == 'This Year') {
      for (var date in successfulSurgeries) {
        if (date.year == now.year) {
          groupedData.update(date.month, (value) => value + 1, ifAbsent: () => 1);
        }
      }
    }

    return groupedData.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            width: 20, // Adjusted width
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPage),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              accountName: Text(widget.username),
              accountEmail: const Text('admin@hospital.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/logo.jpg'),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  DrawerItem(
                    label: 'Dashboard',
                    icon: Icons.dashboard,
                    isSelected: currentPage == 'Dashboard',
                    onTap: () => selectPage('Dashboard'),
                  ),
                  DrawerItem(
                    label: 'User',
                    icon: Icons.person,
                    isSelected: currentPage == 'User',
                    onTap: () => selectPage('User'),
                  ),
                  DrawerItem(
                    label: 'Inventory',
                    icon: Icons.inventory,
                    isSelected: currentPage == 'Inventory',
                    onTap: () => selectPage('Inventory'),
                  ),
                  DrawerItem(
                    label: 'Schedule',
                    icon: Icons.schedule,
                    isSelected: currentPage == 'Schedule',
                    onTap: () => selectPage('Schedule'),
                  ),
                  DrawerItem(
                    label: 'Report',
                    icon: Icons.assessment,
                    isSelected: currentPage == 'Report',
                    onTap: () => selectPage('Report'),
                  ),
                  DrawerItem(
                    label: 'Logs',
                    icon: Icons.list_alt,
                    isSelected: currentPage == 'Logs',
                    onTap: () => selectPage('Logs'),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) {
            if (currentPage == 'Dashboard') {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to the Dashboard, ${widget.username}!',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Successful Surgeries',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: selectedFilter,
                          items: const [
                            DropdownMenuItem(value: 'Today', child: Text('Today')),
                            DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                            DropdownMenuItem(value: 'This Year', child: Text('This Year')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedFilter = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: selectedFilter == 'This Month' ? 750 : MediaQuery.of(context).size.width,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceEvenly,
                              barTouchData: BarTouchData(enabled: true),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (selectedFilter) {
                                        case 'Today':
                                          return Text('${value.toInt()}h');
                                        case 'This Month':
                                          return Text('${value.toInt()}');
                                        case 'This Year':
                                          const monthNames = [
                                            '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                          ];
                                          final month = value.toInt();
                                          if (month >= 1 && month <= 12) {
                                            return Text(monthNames[month]);
                                          }
                                          return const Text('');
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: _generateBarData(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Inventory Alerts',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...lowStockItems.map((item) {
                      return Card(
                        color: Colors.red.shade50,
                        child: ListTile(
                          leading: const Icon(Icons.warning, color: Colors.red),
                          title: Text(item['name']),
                          subtitle: Text('Quantity: ${item['quantity']}'),
                          trailing: const Text(
                            'Low Stock',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            } else if (currentPage == 'User') {
              return const UserPage();
            } else if (currentPage == 'Inventory') {
              return const InventoryPage();
            } else if (currentPage == 'Schedule') {
              return const SchedulePage();
            } else if (currentPage == 'Report') {
              return const ReportPage();
            } else if (currentPage == 'Logs') {
              return const LogsPage();
            } else {
              return Center(
                child: Text(
                  '$currentPage Page',
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.green : null),
      title: Text(label),
      selected: isSelected,
      selectedTileColor: Colors.green.shade100,
      onTap: onTap,
    );
  }
}
