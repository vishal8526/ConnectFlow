import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../admin/admin_employee_detail_screen.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  // Mock employee data
  final List<Map<String, dynamic>> _employees = [
    {
      'id': 'emp_001',
      'name': 'John Doe',
      'email': 'john@company.com',
      'status': 'online',
      'callsToday': 12,
      'progress': 0.8,
    },
    {
      'id': 'emp_002',
      'name': 'Jane Smith',
      'email': 'jane@company.com',
      'status': 'on_call',
      'callsToday': 8,
      'progress': 0.6,
    },
    {
      'id': 'emp_003',
      'name': 'Mike Johnson',
      'email': 'mike@company.com',
      'status': 'offline',
      'callsToday': 15,
      'progress': 1.0,
    },
    {
      'id': 'emp_004',
      'name': 'Sarah Wilson',
      'email': 'sarah@company.com',
      'status': 'online',
      'callsToday': 5,
      'progress': 0.3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Admin Dashboard',
        onSettings: () {},
        onLogout: () => Navigator.of(context).pushReplacementNamed('/'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary cards
          _buildSummaryCards(),
          const SizedBox(height: 24),
          
          // Employee list
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Employees (${_employees.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _refreshEmployees,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._employees.map((employee) => _buildEmployeeCard(employee)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalCalls = _employees.fold<int>(0, (sum, emp) => sum + (emp['callsToday'] as int));
    final onlineCount = _employees.where((emp) => emp['status'] == 'online').length;
    final onCallCount = _employees.where((emp) => emp['status'] == 'on_call').length;
    final avgProgress = _employees.fold<double>(0, (sum, emp) => sum + emp['progress']) / _employees.length;

    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Total Calls', totalCalls.toString(), Icons.phone, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard('Online', onlineCount.toString(), Icons.circle, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard('On Call', onCallCount.toString(), Icons.phone_in_talk, Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard('Avg Progress', '${(avgProgress * 100).toInt()}%', Icons.trending_up, Colors.purple)),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(employee['status']),
          child: Text(
            employee['name'].split(' ').map((n) => n[0]).join(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(employee['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${employee['callsToday']} calls today'),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: employee['progress'],
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                employee['progress'] >= 1.0 ? Colors.green : Colors.blue,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(employee['status']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                employee['status'].replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(employee['status']),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AdminEmployeeDetailScreen(),
            settings: RouteSettings(arguments: employee),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'on_call':
        return Colors.orange;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _refreshEmployees() {
    setState(() {
      // Simulate refresh by updating some data
      for (var employee in _employees) {
        if (employee['status'] == 'online') {
          employee['callsToday'] = (employee['callsToday'] as int) + 1;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Employee data refreshed')),
    );
  }
}


