// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment

import 'package:shabdamitra/db/data_manager.dart';
import 'package:shabdamitra/db/synset.dart';
import 'package:shabdamitra/db/word.dart';

import 'gender.dart';

class WordSynset {
  DataManager dataManager;
  Word word;
  Synset synset;
  Gender gender;
  late final String audioURL;
  late final String imageURL;
  String _pluralForm = '';
  bool _gotPluralForm = false;
  List<Word> _synonyms = <Word>[];
  bool _gotSynonyms = false;
  List<String> _opposites = <String>[];
  bool _gotOpposites = false;

  WordSynset({
    required this.dataManager,
    required this.word,
    required this.synset,
    required this.gender,
  }) {
    audioURL =
        'https://www.cfilt.iitb.ac.in/hindishabdamitra-frontend/static/audio/' +
            word.word +
            '_' +
            synset.synsetId.toString() +
            '.wav';
    imageURL =
        'https://www.cfilt.iitb.ac.in/hindishabdamitra-frontend/static/images/' +
            word.word +
            '_' +
            synset.synsetId.toString() +
            '.jpg';
  }

  Future<List<Word>> getSynonyms() async {
    if (!_gotSynonyms) {
      _synonyms = await dataManager.getSynonyms(word.wordId, synset.synsetId);
      _gotSynonyms = true;
    }
    return _synonyms;
  }

  Future<String> getPluralForm() async {
    if (!_gotPluralForm) {
      _pluralForm =
          await dataManager.getPluralForm(word.wordId, synset.synsetId);
      _gotPluralForm = true;
    }
    return _pluralForm;
  }

  Future<List<String>> getOpposites() async {
    if (!_gotOpposites) {
      _opposites = await dataManager.getOpposites(word.wordId, synset.synsetId);
      _gotOpposites = true;
    }
    return _opposites;
  }
}
