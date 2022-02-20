import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/db_manager.dart';
import 'package:shabdamitra/db/enums.dart';
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
    return Word(wordId: wordId, word: word);
  }

  Future<List<Lesson>> getLessons() async {
    if (_board == null || _standard == null) {
      throw Exception('Cannot get lessons without board and standard hints');
    }
    return _dbManager.getLessons(_board!, _standard!).then((list) {
      return list.map((lessonId) => Lesson(lessonId: lessonId)).toList();
    });
  }

  Future<List<Word>> getLessonWords(int lesson) async {
    return _dbManager.getLessonWords(_board!, _standard!, lesson).then((list) {
      return list.map((map) {
        return Word(wordId: map['word_id'] as int, word: map['word'] as String);
      }).toList();
    });
  }

  Future<List<WordSynset>> getWordSynsets(Word word) async {
    List<Synset> synsets = await getSynsets(word);
    return synsets.map((synset) {
      return WordSynset(
        word: word,
        synset: synset,
      );
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
      List<Map<String, Object?>> examples =
          await _dbManager.getExamples(conceptDefinition['synset_id'] as int);
      examples = [
        ...{...examples}
      ];
      synsets.add(Synset(
          synsetId: conceptDefinition['synset_id'] as int,
          conceptDefinition: ApplicationContext().showSimplifiedData()
              ? (conceptDefinition['simplified_gloss'] != null &&
                      conceptDefinition['simplified_gloss'] as String != '')
                  ? conceptDefinition['simplified_gloss'] as String
                  : conceptDefinition['concept_definition'] as String
              : conceptDefinition['concept_definition'] as String,
          examples: examples
              .map((example) => ApplicationContext().showSimplifiedData()
                  ? (example['simplified_example'] != null &&
                          example['simplified_example'] as String != '')
                      ? example['simplified_example'] as String
                      : example['example_content'] as String
                  : example['example_content'] as String)
              .toList()));
    }
    return synsets;
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
    List<WordSynset> antonymsWS = <WordSynset>[];
    for (var antonym in antonyms) {
      String word = await _dbManager.getWordFromId(antonym['word_id'] as int);
      String conceptDefinition = await _dbManager
          .getSynsetConceptDefinition(antonym['synset_id'] as int);
      var examples = await _dbManager.getExamples(antonym['synset_id'] as int);
      examples = [
        ...{...examples}
      ];
      antonymsWS.add(WordSynset(
          word: Word(wordId: antonym['word_id'] as int, word: word),
          synset: Synset(
              synsetId: antonym['synset_id'] as int,
              conceptDefinition: conceptDefinition,
              examples: examples
                  .map((example) => example['example_content'] as String)
                  .toList())));
    }
    return antonymsWS;
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
    List<WordSynset> hypernyms = <WordSynset>[];
    for (var row in rows) {
      int synsetId = row['child_synset_id'] as int;
      int wordId = (await _dbManager.getWordIdsForSynsetId(synsetId, 1))[0];
      String conceptDefinition =
          await _dbManager.getSynsetConceptDefinition(synsetId);
      var examples = await _dbManager.getExamples(synsetId);
      examples = [
        ...{...examples}
      ];
      String word = await _dbManager.getWordFromId(wordId);
      hypernyms.add(WordSynset(
          word: Word(wordId: wordId, word: word),
          synset: Synset(
              synsetId: synsetId,
              conceptDefinition: conceptDefinition,
              examples: examples
                  .map((example) => example['example_content'] as String)
                  .toList())));
    }
    return hypernyms;
  }

  Future<List<WordSynset>> getHyponyms(Synset synset) async {
    var rows = await _dbManager.getHyponyms(synset.synsetId);
    List<WordSynset> hyponyms = <WordSynset>[];
    for (var row in rows) {
      int synsetId = row['child_synset_id'] as int;
      int wordId = (await _dbManager.getWordIdsForSynsetId(synsetId, 1))[0];
      String conceptDefinition =
          await _dbManager.getSynsetConceptDefinition(synsetId);
      var examples = await _dbManager.getExamples(synsetId);
      examples = [
        ...{...examples}
      ];
      String word = await _dbManager.getWordFromId(wordId);
      hyponyms.add(WordSynset(
          word: Word(wordId: wordId, word: word),
          synset: Synset(
              synsetId: synsetId,
              conceptDefinition: conceptDefinition,
              examples: examples
                  .map((example) => example['example_content'] as String)
                  .toList())));
    }
    return hyponyms;
  }

  Future<List<WordSynset>> getMeronyms(Synset synset) async {
    var rows = await _dbManager.getMeronyms(synset.synsetId);
    List<WordSynset> meronyms = <WordSynset>[];
    for (var row in rows) {
      int synsetId = row['child_synset_id'] as int;
      int wordId = (await _dbManager.getWordIdsForSynsetId(synsetId, 1))[0];
      String conceptDefinition =
          await _dbManager.getSynsetConceptDefinition(synsetId);
      var examples = await _dbManager.getExamples(synsetId);
      examples = [
        ...{...examples}
      ];
      String word = await _dbManager.getWordFromId(wordId);
      meronyms.add(WordSynset(
          word: Word(wordId: wordId, word: word),
          synset: Synset(
              synsetId: synsetId,
              conceptDefinition: conceptDefinition,
              examples: examples
                  .map((example) => example['example_content'] as String)
                  .toList())));
    }
    return meronyms;
  }

  Future<List<WordSynset>> getHolonyms(Synset synset) async {
    var rows = await _dbManager.getHolonyms(synset.synsetId);
    List<WordSynset> holonyms = <WordSynset>[];
    for (var row in rows) {
      int synsetId = row['part_synset_id'] as int;
      int wordId = (await _dbManager.getWordIdsForSynsetId(synsetId, 1))[0];
      String conceptDefinition =
          await _dbManager.getSynsetConceptDefinition(synsetId);
      var examples = await _dbManager.getExamples(synsetId);
      examples = [
        ...{...examples}
      ];
      String word = await _dbManager.getWordFromId(wordId);
      holonyms.add(WordSynset(
          word: Word(wordId: wordId, word: word),
          synset: Synset(
              synsetId: synsetId,
              conceptDefinition: conceptDefinition,
              examples: examples
                  .map((example) => example['example_content'] as String)
                  .toList())));
    }
    return holonyms;
  }

  Future<List<WordSynset>> getModifiesVerb(Synset synset) async {
    var rows = await _dbManager.getModifiesVerb(synset.synsetId);
    List<WordSynset> modifiesVerb = <WordSynset>[];
    for (var row in rows) {
      int synsetId = row['verb_synset_id'] as int;
      int wordId = (await _dbManager.getWordIdsForSynsetId(synsetId, 1))[0];
      String conceptDefinition =
          await _dbManager.getSynsetConceptDefinition(synsetId);
      var examples = await _dbManager.getExamples(synsetId);
      examples = [
        ...{...examples}
      ];
      String word = await _dbManager.getWordFromId(wordId);
      modifiesVerb.add(WordSynset(
          word: Word(wordId: wordId, word: word),
          synset: Synset(
              synsetId: synsetId,
              conceptDefinition: conceptDefinition,
              examples: examples
                  .map((example) => example['example_content'] as String)
                  .toList())));
    }
    return modifiesVerb;
  }

  Future<List<WordSynset>> getModifiesNoun(Synset synset) async {
    var rows = await _dbManager.getModifiesNoun(synset.synsetId);
    List<WordSynset> modifiesNoun = <WordSynset>[];
    for (var row in rows) {
      int synsetId = row['noun_synset_id'] as int;
      int wordId = (await _dbManager.getWordIdsForSynsetId(synsetId, 1))[0];
      String conceptDefinition =
          await _dbManager.getSynsetConceptDefinition(synsetId);
      var examples = await _dbManager.getExamples(synsetId);
      examples = [
        ...{...examples}
      ];
      String word = await _dbManager.getWordFromId(wordId);
      modifiesNoun.add(WordSynset(
          word: Word(wordId: wordId, word: word),
          synset: Synset(
              synsetId: synsetId,
              conceptDefinition: conceptDefinition,
              examples: examples
                  .map((example) => example['example_content'] as String)
                  .toList())));
    }
    return modifiesNoun;
  }
}
