import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/word_synset.dart';

class Word {
  int wordId;
  String word;

  Word({
    required this.wordId,
    required this.word,
  });

  Future<List<WordSynset>> getWordSynsets() async =>
      ApplicationContext().dataManager.getWordSynsets(this);
}
