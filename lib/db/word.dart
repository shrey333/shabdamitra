import 'package:shabdamitra/db/data_manager.dart';
import 'package:shabdamitra/db/word_synset.dart';

class Word {
  DataManager dataManager;
  int wordId;
  String word;

  Word({
    required this.dataManager,
    required this.wordId,
    required this.word,
  });

  Future<List<Future<WordSynset>>> getWordSynsets() async =>
      dataManager.getWordSynsets(this);
}
