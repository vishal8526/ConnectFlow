import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';

class FeedbackHubScreen extends StatefulWidget {
  const FeedbackHubScreen({super.key});

  @override
  State<FeedbackHubScreen> createState() => _FeedbackHubScreenState();
}

class _FeedbackHubScreenState extends State<FeedbackHubScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<Map<String, dynamic>> _mockFeedback = [
    {
      'id': '1',
      'phone': '+1-555-0123',
      'outcome': 'Success',
      'notes': 'Customer interested in premium package',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'duration': '3:45',
    },
    {
      'id': '2',
      'phone': '+1-555-0124',
      'outcome': 'No Answer',
      'notes': 'Left voicemail',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'duration': '0:30',
    },
    {
      'id': '3',
      'phone': '+1-555-0125',
      'outcome': 'Not Interested',
      'notes': 'Customer declined politely',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'duration': '2:15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Hub'),
        actions: [
          IconButton(
            onPressed: _exportToCSV,
            icon: const Icon(Icons.file_download),
            tooltip: 'Export CSV',
          ),
          IconButton(
            onPressed: _exportToPDF,
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // Date picker
          Card(
            margin: const EdgeInsets.all(16),
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Selected Date'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: _selectDate,
            ),
          ),
          
          // Feedback list
          Expanded(
            child: _mockFeedback.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.feedback_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No feedback for this date'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _mockFeedback.length,
                    itemBuilder: (context, index) {
                      final feedback = _mockFeedback[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getOutcomeColor(feedback['outcome']),
                            child: Text(
                              feedback['outcome'][0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(feedback['phone']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Outcome: ${feedback['outcome']}'),
                              if (feedback['notes'] != null && feedback['notes'].isNotEmpty)
                                Text('Notes: ${feedback['notes']}'),
                              Text(
                                'Time: ${DateFormat('HH:mm').format(feedback['timestamp'])} | Duration: ${feedback['duration']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
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
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Color _getOutcomeColor(String outcome) {
    switch (outcome) {
      case 'Success':
        return Colors.green;
      case 'No Answer':
        return Colors.orange;
      case 'Not Interested':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _exportToCSV() async {
    try {
      final csvData = <List<dynamic>>[
        ['Phone', 'Outcome', 'Notes', 'Time', 'Duration'],
        ..._mockFeedback.map((feedback) => [
          feedback['phone'],
          feedback['outcome'],
          feedback['notes'] ?? '',
          DateFormat('HH:mm').format(feedback['timestamp']),
          feedback['duration'],
        ]),
      ];

      final csvString = const ListToCsvConverter().convert(csvData);
      final fileName = 'feedback_${DateFormat('yyyy-MM-dd').format(_selectedDate)}.csv';

      await Share.shareXFiles(
        [XFile.fromData(Uint8List.fromList(csvString.codeUnits), name: fileName, mimeType: 'text/csv')],
        text: 'Feedback export for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _exportToPDF() async {
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
                    'Feedback Report - ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Total Calls: ${_mockFeedback.length}'),
                pw.SizedBox(height: 20),
                ..._mockFeedback.map((feedback) => pw.Container(
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
                        feedback['phone'],
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Outcome: ${feedback['outcome']}'),
                      if (feedback['notes'] != null && feedback['notes'].isNotEmpty)
                        pw.Text('Notes: ${feedback['notes']}'),
                      pw.Text(
                        'Time: ${DateFormat('HH:mm').format(feedback['timestamp'])} | Duration: ${feedback['duration']}',
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
        name: 'feedback_${DateFormat('yyyy-MM-dd').format(_selectedDate)}.pdf',
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


