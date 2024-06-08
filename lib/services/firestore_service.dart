import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Quiz>> loadQuizzes(String collectionName) async {
    final snapshot = await _db.collection(collectionName).get();
    return snapshot.docs.map((doc) => Quiz.fromFirestore(doc.data())).toList();
  }
}
