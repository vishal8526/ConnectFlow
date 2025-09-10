import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../models/models.dart';
import 'mock_call_screen.dart';

class TaskQueueScreen extends StatefulWidget {
  const TaskQueueScreen({super.key});

  @override
  State<TaskQueueScreen> createState() => _TaskQueueScreenState();
}

class _TaskQueueScreenState extends State<TaskQueueScreen> {
  final List<TaskItem> _mockTasks = [
    TaskItem(
      phone: '+1-555-0123',
      status: 'assigned',
      assigned: DateTime.now(),
    ),
    TaskItem(
      phone: '+1-555-0124',
      status: 'assigned',
      assigned: DateTime.now(),
    ),
    TaskItem(
      phone: '+1-555-0125',
      status: 'completed',
      assigned: DateTime.now().subtract(const Duration(hours: 2)),
      completed: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingTasks = _mockTasks.where((t) => t.status == 'assigned').toList();
    final completedTasks = _mockTasks.where((t) => t.status == 'completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Task Queue"),
        actions: [
          IconButton(
            onPressed: () => _showTaskStats(context),
            icon: const Icon(Icons.analytics),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (pendingTasks.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending Tasks (${pendingTasks.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('Tap a task to start calling'),
                    const SizedBox(height: 12),
                    ...pendingTasks.map((task) => ListTile(
                      leading: const Icon(Icons.phone, color: Colors.orange),
                      title: Text(task.phone),
                      subtitle: Text('Assigned: ${_formatTime(task.assigned)}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _startCall(context, task),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _startCall(context, pendingTasks.first),
                icon: const Icon(Icons.phone),
                label: const Text('Start Calling'),
              ),
            ),
          ] else if (completedTasks.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, size: 64, color: Colors.green),
                    const SizedBox(height: 8),
                    Text(
                      'All Tasks Completed!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text('Great work today!'),
                  ],
                ),
              ),
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.coffee, size: 64, color: Colors.brown),
                    const SizedBox(height: 8),
                    Text(
                      'No Tasks Assigned',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    const Text('Take a break!'),
                  ],
                ),
              ),
            ),
          ],
          if (completedTasks.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed Today (${completedTasks.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...completedTasks.map((task) => ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(task.phone),
                      subtitle: Text('Completed: ${_formatTime(task.completed!)}'),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _startCall(BuildContext context, TaskItem task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MockCallScreen(task: task),
      ),
    );
  }

  void _showTaskStats(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Task Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Tasks: ${_mockTasks.length}'),
            Text('Completed: ${_mockTasks.where((t) => t.status == 'completed').length}'),
            Text('Pending: ${_mockTasks.where((t) => t.status == 'assigned').length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}


