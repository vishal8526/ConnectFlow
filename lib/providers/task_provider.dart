import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _loading = false;
  int _todayCount = 0;

  bool get loading => _loading;
  int get todayCount => _todayCount;

  Future<void> loadTodayCount(String employeeId, String dateKey) async {
    _loading = true;
    notifyListeners();
    try {
      final snapshot = await _db
          .collection('tasks')
          .doc(employeeId)
          .collection('dailyTasks')
          .doc(dateKey)
          .collection('items')
          .get();
      _todayCount = snapshot.size;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}


