import 'package:education_quiz_app/services/quiz_service.dart';
import 'package:education_quiz_app/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizServiceProvider = Provider((ref) => QuizService());
final storageServiceProvider = Provider((ref) => StorageService());
