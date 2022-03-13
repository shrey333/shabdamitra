import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  late Future<Database> _dbFuture;
  late final Database _db;

  DbManager._internal() {
    _dbFuture = getDatabasesPath().then((value) {
      String dbPath = join(value, "shabdamitra_hindi_.db");

      return databaseExists(dbPath).then((exists) {
        if (!exists) {
          try {
            return Directory(dirname(dbPath))
                .create(recursive: true)
                .then((value) {
              return rootBundle
                  .load(join("assets", "shabdamitra.db"))
                  .then((data) {
                List<int> bytes = data.buffer
                    .asUint8List(data.offsetInBytes, data.lengthInBytes);

                File(dbPath).writeAsBytesSync(bytes, flush: true);
                return openDatabase(dbPath).then((db) {
                  _db = db;
                  return _db;
                });
              });
            });
          } catch (_) {
            throw Exception('');
          }
        }

        return openDatabase(dbPath).then((db) {
          _db = db;
          return _db;
        });
      });
    });
  }

  static final DbManager _instance = DbManager._internal();

  factory DbManager() {
    return _instance;
  }

  Future<int> getWordId(String word) async {
    await _dbFuture;
    var result = (await _db
        .rawQuery('SELECT word_id FROM tcp_word WHERE word = ?', [word]));
    if (result.isNotEmpty) {
      return result.first['word_id'] as int;
    }
    throw Exception('No such word exists');
  }

  Future<String> getWordFromWordId(int wordId) async {
    await _dbFuture;
    var result = (await _db
        .rawQuery('SELECT word FROM tcp_word WHERE word_id = ?', [wordId]));
    if (result.isNotEmpty) {
      return result.first['word'] as String;
    }
    throw Exception('Word with given word id does not exist');
  }

  Future<List<Map<String, Object?>>> getSynsetsForWord(int wordId) async {
    await _dbFuture;
    return _db.rawQuery(
        'WITH synset_id(si) AS ( '
        'SELECT DISTINCT synset_id '
        'FROM tcp_synset_words WHERE word_id = ? '
        ') SELECT synset_id, concept_definition, simplified_gloss '
        'FROM synset_id INNER JOIN tcp_synset '
        'ON synset_id.si = tcp_synset.synset_id ',
        [wordId]);
  }

  Future<Examples> getExamples(int synsetId, bool simplified) async {
    await _dbFuture;
    List<Map<String, Object?>> result;
    if (simplified) {
      result = (await _db.rawQuery(
          'SELECT simplified_example '
          'FROM tcp_synset_example '
          'WHERE synset_id = ? ',
          [synsetId]));
      if (result.isEmpty) {
        result = (await _db.rawQuery(
            'SELECT example_content '
            'FROM tcp_synset_example '
            'WHERE synset_id = ? ',
            [synsetId]));
        simplified = false;
      }
    } else {
      result = (await _db.rawQuery(
          'SELECT example_content '
          'FROM tcp_synset_example '
          'WHERE synset_id = ? ',
          [synsetId]));
    }
    return Examples(result, simplified);
  }

  Future<String> getGender(int wordId, int synsetId) async {
    await _dbFuture;
    return _db.rawQuery(
        'SELECT DISTINCT gender '
        'FROM tcp_synset_words '
        'WHERE word_id = ? AND synset_id = ? ',
        [wordId, synsetId]).then((list) => list[0]['gender'] as String);
  }

  Future<List<int>> getLessons(String board, int standard) async {
    await _dbFuture;
    return _db.rawQuery(
        'SELECT DISTINCT lesson_id FROM tcp_word_collection '
        'WHERE board = ? AND class_id = ? AND lesson_id > 0 '
        'ORDER BY lesson_id ',
        [board, standard]).then((list) {
      return list.map((map) => map['lesson_id'] as int).toList();
    });
  }

  Future<List<Map<String, Object?>>> getLessonWordsAndSynsets(
      String board, int standard, int lesson) async {
    await _dbFuture;
    return _db.rawQuery(
        'SELECT word_id, synset_id FROM tcp_word_collection '
        'WHERE board = ? AND class_id = ? AND lesson_id = ? ',
        [board, standard, lesson]);
  }

  Future<List<Map<String, Object?>>> getSynonyms(
      int wordId, int synsetId) async {
    await _dbFuture;
    return _db.rawQuery(
        'WITH word_id(wi) AS ( '
        'SELECT DISTINCT word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id != ?'
        ') SELECT word_id, word '
        'FROM tcp_word INNER JOIN word_id '
        'ON word_id.wi = tcp_word.word_id',
        [synsetId, wordId]);
  }

  Future<String> getPluralForm(int wordId, int synsetId) async {
    await _dbFuture;
    var pluralForm = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') SELECT number '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id '
        'WHERE tcp_word_properties.number != "" ',
        [synsetId, wordId]));
    if (pluralForm.isEmpty) {
      return '';
    } else {
      return pluralForm[0]['number'] as String;
    }
  }

  Future<List<Map<String, Object?>>> getAntonyms(
      int wordId, int synsetId) async {
    await _dbFuture;
    return await _db.rawQuery(
        'SELECT anto_synset_id AS synset_id, anto_word_id AS word_id '
        'FROM tcp_rel_antonymy '
        'WHERE synset_id = ? AND word_id = ? ',
        [synsetId, wordId]);
  }

  Future<String> getSynsetConceptDefinition(int synsetId) async {
    await _dbFuture;
    bool simplified = ApplicationContext().showSimplifiedData();
    var result = await _db.rawQuery(
        'SELECT concept_definition, simplified_gloss '
        'FROM tcp_synset '
        'WHERE synset_id = ? ',
        [synsetId]);
    if (result.isNotEmpty) {
      String conceptDefinitionCol = 'concept_definition';
      if (simplified) {
        if (result.first['simplified_gloss'] != null &&
            result.first['simplified_gloss'] as String != '') {
          conceptDefinitionCol = 'simplified_gloss';
        }
      }
      return result.first[conceptDefinitionCol] as String;
    }
    throw Exception('Synset with given synset id does not exist.');
  }

  Future<String> getPOS(int wordId, int synsetId) async {
    await _dbFuture;
    var rows = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') '
        'SELECT kind_of_noun, verb_category, kind_of_adjective, kind_of_adverb '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id ',
        [synsetId, wordId]));
    Map<String, Object?> cols;
    if (rows.isEmpty) {
      return '';
    } else {
      cols = rows[0];
    }
    if (_checkColsForPOS(cols, 'kind_of_noun')) {
      return cols['kind_of_noun'] as String;
    } else if (_checkColsForPOS(cols, 'verb_category')) {
      return cols['verb_category'] as String;
    } else if (_checkColsForPOS(cols, 'kind_of_adjective')) {
      return cols['kind_of_adjective'] as String;
    } else if (_checkColsForPOS(cols, 'kind_of_adverb')) {
      return cols['kind_of_adverb'] as String;
    } else {
      return '';
    }
  }

  bool _checkColsForPOS(Map<String, Object?> cols, String col) {
    return (cols[col] != null) && (cols[col] as String != '');
  }

  Future<String> getCountability(int wordId, int synsetId) async {
    await _dbFuture;
    var result = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') SELECT countability '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id ',
        [synsetId, wordId]));
    if (result.isEmpty) {
      return '';
    } else {
      if (result[0]['countability'] == null) {
        return '';
      } else {
        return result[0]['countability'] as String;
      }
    }
  }

  Future<Map<String, Object?>> getAffix(int wordId, int synsetId) async {
    await _dbFuture;
    var result = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') SELECT prefix_word, root_word, suffix_word '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id ',
        [synsetId, wordId]));
    if (result.isEmpty) {
      return <String, Object?>{};
    } else {
      return result.first;
    }
  }

  Future<String> getJunction(int wordId, int synsetId) async {
    await _dbFuture;
    var result = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') SELECT sandhi '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id ',
        [synsetId, wordId]));
    if (result.isEmpty) {
      return '';
    } else {
      if (result[0]['sandhi'] == null) {
        return '';
      } else {
        return result[0]['sandhi'] as String;
      }
    }
  }

  Future<String> getTransitivity(int wordId, int synsetId) async {
    await _dbFuture;
    var result = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') SELECT transitivity '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id ',
        [synsetId, wordId]));
    if (result.isEmpty) {
      return '';
    } else {
      if (result[0]['transitivity'] == null) {
        return '';
      } else {
        return result[0]['transitivity'] as String;
      }
    }
  }

  Future<String> getIndeclinable(int wordId, int synsetId) async {
    await _dbFuture;
    var result = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') SELECT indeclinable '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id ',
        [synsetId, wordId]));
    if (result.isEmpty) {
      return '';
    } else {
      if (result[0]['indeclinable'] == null) {
        return '';
      } else {
        return result[0]['indeclinable'] as String;
      }
    }
  }

  Future<List<Map<String, Object?>>> getHypernyms(int synsetId) async {
    await _dbFuture;
    return await _db.rawQuery(
        'SELECT child_synset_id '
        'FROM tcp_master_rel_hypernymy_hyponymy '
        'WHERE parent_synset_id = ? ',
        [synsetId]);
  }

  Future<List<Map<String, Object?>>> getHyponyms(int synsetId) async {
    await _dbFuture;
    return await _db.rawQuery(
        'SELECT parent_synset_id '
        'FROM tcp_master_rel_hypernymy_hyponymy '
        'WHERE child_synset_id = ? ',
        [synsetId]);
  }

  Future<List<Map<String, Object?>>> getMeronyms(int synsetId) async {
    await _dbFuture;
    return await _db.rawQuery(
        'SELECT part_synset_id '
        'FROM tcp_master_rel_meronymy_holonymy '
        'WHERE whole_synset_id = ? ',
        [synsetId]);
  }

  Future<List<Map<String, Object?>>> getHolonyms(int synsetId) async {
    await _dbFuture;
    return await _db.rawQuery(
        'SELECT whole_synset_id '
        'FROM tcp_master_rel_meronymy_holonymy '
        'WHERE part_synset_id = ? ',
        [synsetId]);
  }

  Future<List<Map<String, Object?>>> getModifiesVerb(int synsetId) async {
    await _dbFuture;
    return await _db.rawQuery(
        'SELECT verb_synset_id '
        'FROM tcp_master_rel_adverb_modifies_verb '
        'WHERE adverb_synset_id = ? ',
        [synsetId]);
  }

  Future<List<Map<String, Object?>>> getModifiesNoun(int synsetId) async {
    await _dbFuture;
    return await _db.rawQuery(
        'SELECT noun_synset_id '
        'FROM tcp_master_rel_adjective_modifies_noun '
        'WHERE adjective_synset_id = ? ',
        [synsetId]);
  }

  Future<List<int>> getWordIdsForSynsetId(int synsetId, int limit) async {
    await _dbFuture;
    return (await _db.rawQuery(
            'SELECT word_id '
            'FROM tcp_synset_words '
            'WHERE synset_id = ? '
            'ORDER BY word_order '
            'LIMIT ? ',
            [synsetId, limit]))
        .map((map) => map['word_id'] as int)
        .toList();
  }

  Future<List<Map<String, Object?>>> getSuggestions(String prefix) async {
    await _dbFuture;
    String pattern = prefix + '%';
    return (await _db.rawQuery(
        'SELECT word_id, word FROM tcp_word WHERE word LIKE ?', [pattern]));
  }

  Future<void> ensureDbConnectionClosed() async {
    await _dbFuture;
    _db.close();
  }
}

class Examples {
  List<Map<String, Object?>> examples;
  bool simplified;

  Examples(this.examples, this.simplified);
}
