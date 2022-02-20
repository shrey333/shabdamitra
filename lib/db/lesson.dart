import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/word.dart';

class Lesson {
  int lessonId;

  Lesson({required this.lessonId});

  Future<List<Word>> get words async =>
      ApplicationContext().dataManager.getLessonWords(lessonId);
}
