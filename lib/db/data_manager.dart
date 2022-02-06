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
    return conceptDefinitions.map((map) {
      return Synset(
          dataManager: this,
          synsetId: map['synset_id'] as int,
          conceptDefinition: map['concept_definition'] as String);
    }).toList();
  }
}
