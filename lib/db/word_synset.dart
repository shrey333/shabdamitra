// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment

import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/synset.dart';
import 'package:shabdamitra/db/word.dart';

import 'enums.dart';

class WordSynset {
  Word word;
  Synset synset;
  late final String audioURL;
  late final String imageURL;
  Gender _gender = Gender.unknown;
  bool _gotGender = false;
  String _pluralForm = '';
  bool _gotPluralForm = false;
  List<WordSynset> _synonyms = <WordSynset>[];
  bool _gotSynonyms = false;
  List<WordSynset> _antonyms = <WordSynset>[];
  bool _gotAntonyms = false;
  List<WordSynset> _hypernyms = <WordSynset>[];
  bool _gotHypernyms = false;
  List<WordSynset> _hyponyms = <WordSynset>[];
  bool _gotHyponyms = false;
  List<WordSynset> _meronyms = <WordSynset>[];
  bool _gotMeronyms = false;
  List<WordSynset> _holonyms = <WordSynset>[];
  bool _gotHolonyms = false;
  List<WordSynset> _modifiesVerb = <WordSynset>[];
  bool _gotModifiesVerb = false;
  List<WordSynset> _modifiesNoun = <WordSynset>[];
  bool _gotModifiesNoun = false;
  PartOfSpeechWithSubtype _partOfSpeechWithSubtype =
      PartOfSpeechWithSubtype('');
  bool _gotPOS = false;
  Countability _countability = Countability.unspecified;
  bool _gotCountability = false;
  Affix _affix = Affix();
  bool _gotAffix = false;
  Junction _junction = Junction.unspecified;
  bool _gotJunction = false;
  Transitivity _transitivity = Transitivity.unspecified;
  bool _gotTransitivity = false;
  Indeclinable _indeclinable = Indeclinable.unspecified;
  bool _gotIndeclinable = false;

  WordSynset({
    required this.word,
    required this.synset,
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

  Future<Gender> getGender() async {
    if (!_gotGender) {
      _gender = await ApplicationContext().dataManager.getGender(word, synset);
      _gotGender = true;
    }
    return _gender;
  }

  Future<List<WordSynset>> getSynonyms() async {
    if (!_gotSynonyms) {
      _synonyms =
          await ApplicationContext().dataManager.getSynonyms(word, synset);
      _gotSynonyms = true;
    }
    return _synonyms;
  }

  Future<String> getPluralForm() async {
    if (!_gotPluralForm) {
      _pluralForm =
          await ApplicationContext().dataManager.getPluralForm(word, synset);
      _gotPluralForm = true;
    }
    return _pluralForm;
  }

  Future<List<WordSynset>> getAntonyms() async {
    if (!_gotAntonyms) {
      _antonyms =
          await ApplicationContext().dataManager.getAntonyms(word, synset);
      _gotAntonyms = true;
    }
    return _antonyms;
  }

  Future<PartOfSpeechWithSubtype> getPOS() async {
    if (!_gotPOS) {
      _partOfSpeechWithSubtype =
          await ApplicationContext().dataManager.getPOS(word, synset);
      _gotPOS = true;
    }
    return _partOfSpeechWithSubtype;
  }

  Future<Countability> getCountability() async {
    if (!_gotCountability) {
      _countability =
          await ApplicationContext().dataManager.getCountability(word, synset);
      _gotCountability = true;
    }
    return _countability;
  }

  Future<Affix> getAffix() async {
    if (!_gotAffix) {
      _affix = await ApplicationContext().dataManager.getAffix(word, synset);
      _gotAffix = true;
    }
    return _affix;
  }

  Future<Junction> getJunction() async {
    if (!_gotJunction) {
      _junction =
          await ApplicationContext().dataManager.getJunction(word, synset);
      _gotJunction = true;
    }
    return _junction;
  }

  Future<Transitivity> getTransitivity() async {
    if (!_gotTransitivity) {
      _transitivity =
          await ApplicationContext().dataManager.getTransitivity(word, synset);
      _gotTransitivity = false;
    }
    return _transitivity;
  }

  Future<List<WordSynset>> getHypernyms() async {
    if (!_gotHypernyms) {
      _hypernyms = await ApplicationContext().dataManager.getHypernyms(synset);
      _gotHypernyms = true;
    }
    return _hypernyms;
  }

  Future<List<WordSynset>> getHyponyms() async {
    if (!_gotHyponyms) {
      _hyponyms = await ApplicationContext().dataManager.getHyponyms(synset);
      _gotHyponyms = true;
    }
    return _hyponyms;
  }

  Future<List<WordSynset>> getMeronyms() async {
    if (!_gotMeronyms) {
      _meronyms = await ApplicationContext().dataManager.getMeronyms(synset);
      _gotMeronyms = true;
    }
    return _meronyms;
  }

  Future<List<WordSynset>> getHolonyms() async {
    if (!_gotHolonyms) {
      _holonyms = await ApplicationContext().dataManager.getHolonyms(synset);
      _gotHolonyms = true;
    }
    return _holonyms;
  }

  Future<List<WordSynset>> getModifiesVerb() async {
    if (!_gotModifiesVerb) {
      _modifiesVerb =
          await ApplicationContext().dataManager.getModifiesVerb(synset);
      _gotModifiesVerb = true;
    }
    return _modifiesVerb;
  }

  Future<List<WordSynset>> getModifiesNoun() async {
    if (!_gotModifiesNoun) {
      _modifiesNoun =
          await ApplicationContext().dataManager.getModifiesNoun(synset);
      _gotModifiesNoun = true;
    }
    return _modifiesNoun;
  }

  Future<Indeclinable> getIndeclinable() async {
    if (!_gotIndeclinable) {
      _indeclinable =
          await ApplicationContext().dataManager.getIndeclinable(word, synset);
      _gotIndeclinable = true;
    }
    return _indeclinable;
  }
}
