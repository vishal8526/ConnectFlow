import 'package:flutter/material.dart';
import '../../widgets/app_header.dart';
import '../employee/performance_insights_screen.dart';
import '../employee/task_queue_screen.dart';
import '../employee/feedback_hub_screen.dart';

class DashboardEmployee extends StatelessWidget {
  const DashboardEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Employee Dashboard',
        onSettings: () {},
        onLogout: () => Navigator.of(context).pushReplacementNamed('/'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Performance Insights'),
              subtitle: const Text('Calls made, success rate, duration, talk time'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PerformanceInsightsScreen()),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text("Today's Task Queue"),
              subtitle: const Text('Start calling assigned numbers'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TaskQueueScreen()),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              title: const Text('Feedback Hub'),
              subtitle: const Text('View and export feedback'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FeedbackHubScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


