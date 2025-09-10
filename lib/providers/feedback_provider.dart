import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _loading = false;
  List<Map<String, dynamic>> _items = [];

  bool get loading => _loading;
  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  Future<void> loadForDate(String employeeId, String dateKey) async {
    _loading = true;
    notifyListeners();
    try {
      final snapshot = await _db
          .collection('feedback')
          .doc(employeeId)
          .collection(dateKey)
          .get();
      _items = snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}


