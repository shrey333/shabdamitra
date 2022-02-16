import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
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
    return _db.rawQuery('SELECT word_id FROM tcp_word WHERE word = ?',
        [word]).then((list) => list[0]['word_id'] as int);
  }

  Future<String> getWordFromId(int id) async {
    await _dbFuture;
    return _db.rawQuery('SELECT word FROM tcp_word WHERE word_id = ?',
        [id]).then((list) => list[0]['word'] as String);
  }

  Future<List<Map<String, Object?>>> getSynsets(int wordId) async {
    await _dbFuture;
    return _db.rawQuery(
        'WITH synset_id(si) AS ( '
        'SELECT DISTINCT synset_id '
        'FROM tcp_synset_words WHERE word_id = ? '
        ') SELECT synset_id, concept_definition '
        'FROM synset_id INNER JOIN tcp_synset '
        'ON synset_id.si = tcp_synset.synset_id ',
        [wordId]);
  }

  Future<List<Map<String, Object?>>> getExamples(int synsetId) async {
    await _dbFuture;
    return _db.rawQuery(
        'SELECT example_content FROM tcp_synset_example '
        'WHERE synset_id = ? AND example_content IS NOT NULL '
        'UNION '
        'SELECT simplified_example FROM tcp_synset_example '
        'WHERE synset_id = ? AND simplified_example IS NOT NULL',
        [synsetId, synsetId]);
  }

  Future<List<Map<String, Object?>>> getSynsetsForBoardAndStandard(
      int wordId, String board, int standard) async {
    await _dbFuture;
    return _db.rawQuery(
        'WITH synset_id(si) AS ( '
        'SELECT DISTINCT synset_id '
        'FROM tcp_word_collection '
        'WHERE word_id = ? AND board = ? AND class_id = ? '
        ') SELECT synset_id, concept_definition '
        'FROM synset_id INNER JOIN tcp_synset '
        'ON synset_id.si = tcp_synset.synset_id ',
        [wordId, board, standard]);
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
        'WHERE board = ? AND class_id = ? '
        'ORDER BY lesson_id ',
        [board, standard + 1]).then((list) {
      return list.map((map) => map['lesson_id'] as int).toList();
    });
  }

  Future<List<Map<String, Object?>>> getLessonWords(
      String board, int standard, int lesson) async {
    await _dbFuture;
    return _db.rawQuery(
        'WITH word_id(wi) AS ( '
        'SELECT word_id FROM tcp_word_collection '
        'WHERE board = ? AND class_id = ? AND lesson_id = ? '
        ') SELECT word_id, word '
        'FROM word_id INNER JOIN tcp_word '
        'ON word_id.wi = tcp_word.word_id ',
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
        'WHERE tcp_word_properties.number != ""',
        [synsetId, wordId]));
    if (pluralForm.isEmpty) {
      return '';
    } else {
      return pluralForm[0]['number'] as String;
    }
  }

  Future<List<String>> getOpposites(int wordId, int synsetId) async {
    await _dbFuture;
    var opposites = (await _db.rawQuery(
        'WITH synset_word_id(swi) AS ( '
        'SELECT synset_word_id '
        'FROM tcp_synset_words '
        'WHERE synset_id = ? AND word_id = ? '
        ') SELECT opposite '
        'FROM tcp_word_properties INNER JOIN synset_word_id '
        'ON synset_word_id.swi = tcp_word_properties.synset_word_id '
        'WHERE tcp_word_properties.opposite != \'\'',
        [synsetId, wordId]));
    if (opposites.isEmpty) {
      return List.empty();
    } else {
      return (opposites[0]['opposite'] as String).split(',');
    }
  }

  Future<void> ensureDbConnectionClosed() async {
    await _dbFuture;
    _db.close();
  }
}
