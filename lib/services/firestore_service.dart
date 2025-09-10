import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> users() => _db.collection('users');
  CollectionReference<Map<String, dynamic>> tasks(String employeeId) =>
      _db.collection('tasks').doc(employeeId).collection('dailyTasks');
  CollectionReference<Map<String, dynamic>> feedback(String employeeId, String date) =>
      _db.collection('feedback').doc(employeeId).collection(date);
}


