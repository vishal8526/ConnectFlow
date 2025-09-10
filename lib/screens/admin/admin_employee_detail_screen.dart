import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:typed_data';
import '../../models/models.dart';
import 'package:cross_file/cross_file.dart';

class AdminEmployeeDetailScreen extends StatefulWidget {
  const AdminEmployeeDetailScreen({super.key});

  @override
  State<AdminEmployeeDetailScreen> createState() => _AdminEmployeeDetailScreenState();
}

class _AdminEmployeeDetailScreenState extends State<AdminEmployeeDetailScreen> {
  final String _employeeName = 'John Doe';
  final String _employeeId = 'emp_001';
  
  // Mock data
  final List<TaskItem> _tasks = [
    TaskItem(phone: '+1-555-0123', status: 'assigned', assigned: DateTime.now()),
    TaskItem(phone: '+1-555-0124', status: 'completed', assigned: DateTime.now().subtract(const Duration(hours: 2)), completed: DateTime.now().subtract(const Duration(hours: 1))),
    TaskItem(phone: '+1-555-0125', status: 'assigned', assigned: DateTime.now()),
  ];

  final List<Map<String, dynamic>> _feedback = [
    {'phone': '+1-555-0123', 'outcome': 'Success', 'notes': 'Customer interested', 'timestamp': DateTime.now().subtract(const Duration(hours: 1))},
    {'phone': '+1-555-0124', 'outcome': 'No Answer', 'notes': 'Left voicemail', 'timestamp': DateTime.now().subtract(const Duration(hours: 2))},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$_employeeName Details'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Performance'),
              Tab(text: 'Tasks'),
              Tab(text: 'Feedback'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPerformanceTab(),
            _buildTasksTab(),
            _buildFeedbackTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Employee stats
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Employee Performance', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Total Calls', '45', Icons.phone, Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Success Rate', '78%', Icons.trending_up, Colors.green)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Avg Duration', '4.2m', Icons.timer, Colors.orange)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Talk Time', '189m', Icons.schedule, Colors.purple)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Performance chart
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Performance', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                              return Text(days[value.toInt() % days.length]);
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            const FlSpot(0, 8),
                            const FlSpot(1, 12),
                            const FlSpot(2, 6),
                            const FlSpot(3, 15),
                            const FlSpot(4, 4),
                          ],
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTasksTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Task management header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task Management', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _uploadCSV,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload CSV'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addManualTask,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearTasks,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear All'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _exportTasks,
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Current tasks
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Tasks (${_tasks.length})', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                ..._tasks.map((task) => ListTile(
                  leading: Icon(
                    task.status == 'completed' ? Icons.check_circle : Icons.phone,
                    color: task.status == 'completed' ? Colors.green : Colors.orange,
                  ),
                  title: Text(task.phone),
                  subtitle: Text('Status: ${task.status} | Assigned: ${DateFormat('HH:mm').format(task.assigned)}'),
                  trailing: task.status == 'assigned' 
                    ? IconButton(
                        onPressed: () => _removeTask(task),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      )
                    : null,
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Feedback header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Feedback Review', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _exportFeedbackCSV,
                        icon: const Icon(Icons.file_download),
                        label: const Text('Export CSV'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _exportFeedbackPDF,
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Export PDF'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Feedback list
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Feedback (${_feedback.length})', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                ..._feedback.map((item) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getOutcomeColor(item['outcome']),
                    child: Text(
                      item['outcome'][0],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(item['phone']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Outcome: ${item['outcome']}'),
                      if (item['notes'] != null) Text('Notes: ${item['notes']}'),
                      Text('Time: ${DateFormat('HH:mm').format(item['timestamp'])}'),
                    ],
                  ),
                  isThreeLine: true,
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(title, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Color _getOutcomeColor(String outcome) {
    switch (outcome) {
      case 'Success': return Colors.green;
      case 'No Answer': return Colors.orange;
      case 'Not Interested': return Colors.red;
      default: return Colors.grey;
    }
  }

  Future<void> _uploadCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      
      if (result != null) {
        final file = result.files.first;
        final bytes = file.bytes;
        if (bytes != null) {
          final csvString = String.fromCharCodes(bytes);
          final csvData = const CsvToListConverter().convert(csvString);
          
          // Process CSV data (skip header row)
          final newTasks = csvData.skip(1).map((row) {
            return TaskItem(
              phone: row[0].toString(),
              status: 'assigned',
              assigned: DateTime.now(),
            );
          }).toList();
          
          setState(() {
            _tasks.addAll(newTasks);
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Uploaded ${newTasks.length} tasks from CSV')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  void _addManualTask() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '+1-555-0123',
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _tasks.add(TaskItem(
                    phone: controller.text.trim(),
                    status: 'assigned',
                    assigned: DateTime.now(),
                  ));
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added successfully')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _clearTasks() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Tasks'),
        content: const Text('Are you sure you want to remove all tasks for this employee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() => _tasks.clear());
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All tasks cleared')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _removeTask(TaskItem task) {
    setState(() => _tasks.remove(task));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task removed')),
    );
  }

  Future<void> _exportTasks() async {
    try {
      final csvData = <List<dynamic>>[
        ['Phone', 'Status', 'Assigned', 'Completed'],
        ..._tasks.map((task) => [
          task.phone,
          task.status,
          DateFormat('yyyy-MM-dd HH:mm').format(task.assigned),
          task.completed != null ? DateFormat('yyyy-MM-dd HH:mm').format(task.completed!) : '',
        ]),
      ];

      final csvString = const ListToCsvConverter().convert(csvData);
      final fileName = 'tasks_${_employeeName.replaceAll(' ', '_')}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.csv';

      await Share.shareXFiles(
        [XFile.fromData(Uint8List.fromList(csvString.codeUnits), name: fileName, mimeType: 'text/csv')],
        text: 'Tasks for $_employeeName',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _exportFeedbackCSV() async {
    try {
      final csvData = <List<dynamic>>[
        ['Phone', 'Outcome', 'Notes', 'Timestamp'],
        ..._feedback.map((item) => [
          item['phone'],
          item['outcome'],
          item['notes'] ?? '',
          DateFormat('yyyy-MM-dd HH:mm').format(item['timestamp']),
        ]),
      ];

      final csvString = const ListToCsvConverter().convert(csvData);
      final fileName = 'feedback_${_employeeName.replaceAll(' ', '_')}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.csv';

      await Share.shareXFiles(
        [XFile.fromData(Uint8List.fromList(csvString.codeUnits), name: fileName, mimeType: 'text/csv')],
        text: 'Feedback for $_employeeName',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _exportFeedbackPDF() async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    'Feedback Report - $_employeeName',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Total Feedback Entries: ${_feedback.length}'),
                pw.SizedBox(height: 20),
                ..._feedback.map((item) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        item['phone'],
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Outcome: ${item['outcome']}'),
                      if (item['notes'] != null && item['notes'].isNotEmpty)
                        pw.Text('Notes: ${item['notes']}'),
                      pw.Text(
                        'Time: ${DateFormat('HH:mm').format(item['timestamp'])}',
                        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                )),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'feedback_${_employeeName.replaceAll(' ', '_')}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF export failed: $e')),
        );
      }
    }
  }
}


