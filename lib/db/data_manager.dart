import 'package:shabdamitra/db/db_manager.dart';
import 'package:shabdamitra/db/gender.dart';
import 'package:shabdamitra/db/lesson.dart';
import 'package:shabdamitra/db/synset.dart';
import 'package:shabdamitra/db/word.dart';
import 'package:shabdamitra/db/word_synset.dart';

class DataManager {
  final DbManager _dbManager = DbManager();

  String? _board;
  int? _standard;

  DataManager();

  DataManager.withHints(String board, int standard) {
    _board = board;
    _standard = standard;
  }

  Future<Word> getWord(String word) async {
    var wordId = await _dbManager.getWordId(word);
    return Word(dataManager: this, wordId: wordId, word: word);
  }

  Future<List<Lesson>> getLessons() async {
    if (_board == null || _standard == null) {
      throw Exception('Cannot get lessons without board and standard hints');
    }
    return _dbManager.getLessons(_board!, _standard!).then((list) {
      return list
          .map((lessonId) => Lesson(dataManager: this, lessonId: lessonId))
          .toList();
    });
  }

  Future<List<Word>> getLessonWords(int lesson) async {
    return _dbManager.getLessonWords(_board!, _standard!, lesson).then((list) {
      return list.map((map) {
        return Word(
            dataManager: this,
            wordId: map['word_id'] as int,
            word: map['word'] as String);
      }).toList();
    });
  }

  Future<List<Future<WordSynset>>> getWordSynsets(Word word) async {
    List<Synset> synsets = await getSynsets(word);
    return synsets.map((synset) {
      return _dbManager.getGender(word.wordId, synset.synsetId).then((gender) {
        return WordSynset(
            dataManager: this,
            word: word,
            synset: synset,
            gender: genderFrom(gender));
      });
    }).toList();
  }

  Future<List<Synset>> getSynsets(Word word) async {
    List<Map<String, Object?>> conceptDefinitions;
    if (_board != null && _standard != null) {
      conceptDefinitions = await _dbManager.getSynsetsForBoardAndStandard(
          word.wordId, _board!, _standard!);
    } else {
      conceptDefinitions = await _dbManager.getSynsets(word.wordId);
    }
    List<Synset> synsets = <Synset>[];
    for (var conceptDefinition in conceptDefinitions) {
      var examples =
          await _dbManager.getExamples(conceptDefinition['synset_id'] as int);
      synsets.add(Synset(
          dataManager: this,
          synsetId: conceptDefinition['synset_id'] as int,
          conceptDefinition: conceptDefinition['concept_definition'] as String,
          examples: examples
              .map((example) => example['example_content'] as String)
              .toList()));
    }
    return synsets;
  }

  Future<List<Word>> getSynonyms(int wordId, int synsetId) async {
    var synonyms = await _dbManager.getSynonyms(wordId, synsetId);
    return synonyms.map((synonym) {
      return Word(
          dataManager: this,
          wordId: synonym['word_id'] as int,
          word: synonym['word'] as String);
    }).toList();
  }

  Future<String> getPluralForm(int wordId, int synsetId) {
    return _dbManager.getPluralForm(wordId, synsetId);
  }

  Future<List<Word>> getOpposites(int wordId, int synsetId) async {
    var opposites = await _dbManager.getOpposites(wordId, synsetId);
    var oppositeWords = <Word>[];
    for (var opposite in opposites) {
      oppositeWords.add(await getWord(opposite));
    }
    return oppositeWords;
  }
}
