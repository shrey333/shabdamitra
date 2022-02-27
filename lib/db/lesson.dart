import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/word_synset.dart';

class Lesson {
  int lessonId;
  final List<WordSynset> _wordSynsets = <WordSynset>[];
  bool _gotWordSynsets = false;

  Lesson({required this.lessonId});

  Future<List<WordSynset>> getLessonWordSynsets() async {
    if (!_gotWordSynsets) {
      _wordSynsets.addAll(
          await ApplicationContext().dataManager.getLessonWordSynsets(this));
      _gotWordSynsets = true;
    }
    return _wordSynsets;
  }
}
