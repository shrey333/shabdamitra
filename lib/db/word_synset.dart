import 'package:shabdamitra/db/data_manager.dart';
import 'package:shabdamitra/db/synset.dart';
import 'package:shabdamitra/db/word.dart';

import 'gender.dart';

class WordSynset {
  static const baseURL =
      'https://www.cfilt.iitb.ac.in/hindishabdamitra-frontend/static/';

  DataManager dataManager;
  Word word;
  Synset synset;
  Gender gender;
  late String audioURL;
  late String imageURL;

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
        'https://www.cfilt.iitb.ac.in/hindishabdamitra-frontend/static/' +
            word.word +
            '_' +
            synset.synsetId.toString() +
            '.jpg';
  }
}
