import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/word_synset.dart';

class Word {
  int wordId;
  String word;
  List<WordSynset> _wordSynsets = <WordSynset>[];
  bool _gotWordSynsets = false;

  Word({
    required this.wordId,
    required this.word,
  });

  Future<List<WordSynset>> getWordSynsets() async {
    if (!_gotWordSynsets) {
      _wordSynsets =
          await ApplicationContext().dataManager.getWordSynsetsForWord(this);
      _gotWordSynsets = true;
    }
    return _wordSynsets;
  }
}
