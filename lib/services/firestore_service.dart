import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Quiz>> loadQuizzes(String collectionName) async {
    try {
      final snapshot = await _db.collection(collectionName).get();
      if (snapshot.docs.isEmpty) {
        throw Exception("No quizzes found for the year $collectionName");
      }
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Quiz.fromFirestore(data);
      }).toList();
    } catch (e) {
      print("Error loading quizzes: $e");
      rethrow;
    }
  }
}
