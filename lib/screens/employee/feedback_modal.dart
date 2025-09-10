import 'package:flutter/material.dart';
import '../../models/models.dart';

class FeedbackModal extends StatefulWidget {
  final TaskItem task;
  final Duration callDuration;
  final Function(String outcome, String? notes) onSave;

  const FeedbackModal({
    super.key,
    required this.task,
    required this.callDuration,
    required this.onSave,
  });

  @override
  State<FeedbackModal> createState() => _FeedbackModalState();
}

class _FeedbackModalState extends State<FeedbackModal> {
  final TextEditingController _notesController = TextEditingController();
  String _selectedOutcome = 'Success';
  final List<String> _outcomes = [
    'Success',
    'No Answer',
    'Busy',
    'Wrong Number',
    'Not Interested',
    'Callback Requested',
    'Do Not Call',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.feedback, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Call Feedback',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Call details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Call Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Number: ${widget.task.phone}'),
                  Text('Duration: ${_formatDuration(widget.callDuration)}'),
                  Text('Time: ${_formatTime(DateTime.now())}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Outcome selection
          Text(
            'Call Outcome',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedOutcome,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _outcomes.map((outcome) {
              return DropdownMenuItem(
                value: outcome,
                child: Text(outcome),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedOutcome = value!);
            },
          ),
          const SizedBox(height: 16),
          
          // Notes
          Text(
            'Notes (Optional)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Add any additional notes about the call...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onSave(_selectedOutcome, _notesController.text.trim().isEmpty 
                        ? null 
                        : _notesController.text.trim());
                  },
                  child: const Text('Save & Call Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
