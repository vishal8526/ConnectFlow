import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'Employee' | 'Admin'
  final String status; // 'online' | 'offline' | 'on_call'
  final Map<String, dynamic> stats;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.stats,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) => AppUser(
    id: id,
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    role: data['role'] ?? 'Employee',
    status: data['status'] ?? 'offline',
    stats: Map<String, dynamic>.from(data['stats'] ?? {}),
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'role': role,
    'status': status,
    'stats': stats,
  };
}

class TaskItem {
  final String phone;
  final String status; // 'assigned' | 'completed' | 'in_progress'
  final String? notes;
  final DateTime assigned;
  final DateTime? completed;

  TaskItem({
    required this.phone,
    required this.status,
    required this.assigned,
    this.completed,
    this.notes,
  });

  factory TaskItem.fromMap(Map<String, dynamic> data) => TaskItem(
    phone: data['phone'] ?? '',
    status: data['status'] ?? 'assigned',
    notes: data['notes'],
    assigned: (data['assigned'] as Timestamp).toDate(),
    completed: (data['completed'] != null)
        ? (data['completed'] as Timestamp).toDate()
        : null,
  );

  Map<String, dynamic> toMap() => {
    'phone': phone,
    'status': status,
    'notes': notes,
    'assigned': assigned,
    'completed': completed,
  };
}

class FeedbackItem {
  final String id;
  final String outcome; // e.g. 'Success', 'No Answer'
  final String? notes;
  final DateTime timestamp;

  FeedbackItem({
    required this.id,
    required this.outcome,
    this.notes,
    required this.timestamp,
  });

  factory FeedbackItem.fromMap(String id, Map<String, dynamic> data) =>
      FeedbackItem(
        id: id,
        outcome: data['outcome'] ?? '',
        notes: data['notes'],
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
    'outcome': outcome,
    'notes': notes,
    'timestamp': timestamp,
  };
}
