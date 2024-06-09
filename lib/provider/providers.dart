import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:generation_quiz_app/services/quiz_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());
final storageServiceProvider = Provider((ref) => StorageService());
final quizServiceProvider = Provider((ref) => QuizService());
