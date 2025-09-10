import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'feedback_modal.dart';

class MockCallScreen extends StatefulWidget {
  final TaskItem task;

  const MockCallScreen({super.key, required this.task});

  @override
  State<MockCallScreen> createState() => _MockCallScreenState();
}

class _MockCallScreenState extends State<MockCallScreen> {
  bool _isCalling = false;
  bool _callEnded = false;
  Duration _callDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startMockCall();
  }

  void _startMockCall() {
    setState(() => _isCalling = true);
    
    // Simulate call duration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCalling = false;
          _callEnded = true;
          _callDuration = const Duration(seconds: 3);
        });
      }
    });
  }

  void _endCall() {
    setState(() {
      _isCalling = false;
      _callEnded = true;
    });
  }

  void _showFeedbackModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FeedbackModal(
        task: widget.task,
        callDuration: _callDuration,
        onSave: (outcome, notes) {
          // TODO: Save to Firestore
          Navigator.of(context).pop(); // Close modal
          Navigator.of(context).pop(); // Go back to task queue
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback saved!')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call in Progress'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _callEnded ? () => Navigator.of(context).pop() : null,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Phone number display
              Text(
                widget.task.phone,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              
              // Call status
              if (_isCalling) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Connecting...'),
              ] else if (_callEnded) ...[
                const Icon(
                  Icons.call_end,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Call Ended',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('Duration: ${_formatDuration(_callDuration)}'),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _showFeedbackModal,
                  icon: const Icon(Icons.feedback),
                  label: const Text('Add Feedback'),
                ),
              ],
              
              const SizedBox(height: 48),
              
              // Call controls
              if (_isCalling)
                FilledButton.icon(
                  onPressed: _endCall,
                  icon: const Icon(Icons.call_end),
                  label: const Text('End Call'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
