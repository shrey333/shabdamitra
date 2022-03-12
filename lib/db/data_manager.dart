import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/db_manager.dart';
import 'package:shabdamitra/db/enums.dart';
import 'package:shabdamitra/db/lesson.dart';
import 'package:shabdamitra/db/synset.dart';
import 'package:shabdamitra/db/word.dart';
import 'package:shabdamitra/db/word_synset.dart';

class DataManager {
  final DbManager _dbManager = DbManager();

  Future<Word> getWord(String word) async {
    try {
      var wordId = await _dbManager.getWordId(word);
      return Word(wordId: wordId, word: word);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future<Word> _getWordFromWordId(int wordId) async {
    try {
      String word = await _dbManager.getWordFromWordId(wordId);
      return Word(wordId: wordId, word: word);
    } catch (ex) {
      return Future.error(ex);
    }
  }

  Future<List<Lesson>> getLessons() async {
    if (ApplicationContext().isUserStudent()) {
      return _dbManager
          .getLessons(ApplicationContext().getStudentBoard(),
              ApplicationContext().getStudentStandard())
          .then((list) {
        return list.map((lessonId) => Lesson(lessonId: lessonId)).toList();
      });
    }
    throw Exception('Cannot get lessons for Learner.');
  }

  Future<List<WordSynset>> getLessonWordSynsets(Lesson lesson) async {
    if (ApplicationContext().isUserStudent()) {
      var result = await _dbManager.getLessonWordsAndSynsets(
          ApplicationContext().getStudentBoard(),
          ApplicationContext().getStudentStandard(),
          lesson.lessonId);
      return _getWordSynsetsFromRows(result, 'synset_id');
    }
    throw Exception('Cannot get lessons for Learner.');
  }

  Future<List<WordSynset>> getWordSynsetsForWord(Word word) async {
    List<Map<String, Object?>> result =
        await _dbManager.getSynsetsForWord(word.wordId);
    List<WordSynset> wordSynsets = <WordSynset>[];
    for (var row in result) {
      int synsetId = row['synset_id'] as int;
      wordSynsets.add(WordSynset(
          word: word, synset: await _getSynsetFromSynsetId(synsetId)));
    }
    return wordSynsets;
  }

  Future<List<WordSynset>> getSynonyms(Word word, Synset synset) async {
    var synonyms = await _dbManager.getSynonyms(word.wordId, synset.synsetId);
    return synonyms.map((synonym) {
      return WordSynset(
        word: Word(
            wordId: synonym['word_id'] as int, word: synonym['word'] as String),
        synset: synset,
      );
    }).toList();
  }

  Future<String> getPluralForm(Word word, Synset synset) {
    return _dbManager.getPluralForm(word.wordId, synset.synsetId);
  }

  Future<List<WordSynset>> getAntonyms(Word word, Synset synset) async {
    var antonyms = await _dbManager.getAntonyms(word.wordId, synset.synsetId);
    return _getWordSynsetsFromRows(antonyms, 'synset_id');
  }

  Future<Gender> getGender(Word word, Synset synset) async {
    return genderFrom(await _dbManager.getGender(word.wordId, synset.synsetId));
  }

  Future<PartOfSpeechWithSubtype> getPOS(Word word, Synset synset) async {
    return PartOfSpeechWithSubtype(
        await _dbManager.getPOS(word.wordId, synset.synsetId));
  }

  Future<Countability> getCountability(Word word, Synset synset) async {
    return countabilityFrom(
        await _dbManager.getCountability(word.wordId, synset.synsetId));
  }

  Future<Affix> getAffix(Word word, Synset synset) async {
    var cols = await _dbManager.getAffix(word.wordId, synset.synsetId);
    if (cols['prefix_word'] != null && cols['prefix_word'] as String != '') {
      return Affix.prefix(
          cols['root_word'] as String, cols['prefix_word'] as String);
    } else if (cols['prefix_word'] != null &&
        cols['prefix_word'] as String != '') {
      return Affix.prefix(
          cols['root_word'] as String, cols['prefix_word'] as String);
    } else {
      return Affix();
    }
  }

  Future<Junction> getJunction(Word word, Synset synset) async {
    return junctionFrom(
        await _dbManager.getJunction(word.wordId, synset.synsetId));
  }

  Future<Transitivity> getTransitivity(Word word, Synset synset) async {
    return transitivityFrom(
        await _dbManager.getTransitivity(word.wordId, synset.synsetId));
  }

  Future<Indeclinable> getIndeclinable(Word word, Synset synset) async {
    return indeclinableFrom(
        await _dbManager.getIndeclinable(word.wordId, synset.synsetId));
  }

  Future<List<WordSynset>> getHypernyms(Synset synset) async {
    var rows = await _dbManager.getHypernyms(synset.synsetId);
    return _getWordSynsetsFromRows(rows, 'child_synset_id');
  }

  Future<List<WordSynset>> getHyponyms(Synset synset) async {
    var rows = await _dbManager.getHyponyms(synset.synsetId);
    return _getWordSynsetsFromRows(rows, 'parent_synset_id');
  }

  Future<List<WordSynset>> getMeronyms(Synset synset) async {
    var rows = await _dbManager.getMeronyms(synset.synsetId);
    return _getWordSynsetsFromRows(rows, 'part_synset_id');
  }

  Future<List<WordSynset>> getHolonyms(Synset synset) async {
    var rows = await _dbManager.getHolonyms(synset.synsetId);
    return _getWordSynsetsFromRows(rows, 'whole_synset_id');
  }

  Future<List<WordSynset>> getModifiesVerb(Synset synset) async {
    var rows = await _dbManager.getModifiesVerb(synset.synsetId);
    return _getWordSynsetsFromRows(rows, 'verb_synset_id');
  }

  Future<List<WordSynset>> getModifiesNoun(Synset synset) async {
    var rows = await _dbManager.getModifiesNoun(synset.synsetId);
    return _getWordSynsetsFromRows(rows, 'noun_synset_id');
  }

  Future<List<WordSynset>> _getWordSynsetsFromRows(
      List<Map<String, Object?>> rows, String synsetIdCol) async {
    List<WordSynset> wordSynsets = <WordSynset>[];
    for (var row in rows) {
      try {
        int synsetId = row[synsetIdCol] as int;
        int wordId = (await _dbManager.getWordIdsForSynsetId(synsetId, 1))[0];
        wordSynsets.add(WordSynset(
            word: await _getWordFromWordId(wordId),
            synset: await _getSynsetFromSynsetId(synsetId)));
      } catch (_) {
        continue;
      }
    }
    return wordSynsets;
  }

  Future<Synset> _getSynsetFromSynsetId(int synsetId) async {
    String conceptDefinition =
        await _dbManager.getSynsetConceptDefinition(synsetId);
    Examples examples = await _dbManager.getExamples(
        synsetId, ApplicationContext().showSimplifiedData());
    examples.examples = [
      ...{...examples.examples}
    ];
    String exampleCol =
        examples.simplified ? 'simplified_example' : 'example_content';
    List<String> examples_ = <String>[];
    for (Map<String, Object?> example in examples.examples) {
      if (example[exampleCol] != null && example[exampleCol] as String != '') {
        examples_.add(example[exampleCol] as String);
      }
    }
    return Synset(
        synsetId: synsetId,
        conceptDefinition: conceptDefinition,
        examples: examples_);
  }

  Future<List<String>> getSuggestions(String prefix) async {
    return (await _dbManager.getSuggestions(prefix))
        .map((row) => row['word'] as String)
        .toList();
  }
}
