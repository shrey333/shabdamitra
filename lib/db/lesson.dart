import 'package:shabdamitra/db/data_manager.dart';
import 'package:shabdamitra/db/word.dart';

class Lesson {
  DataManager dataManager;
  int lessonId;

  Lesson({required this.dataManager, required this.lessonId});

  Future<List<Word>> get words async => dataManager.getLessonWords(lessonId);
}
