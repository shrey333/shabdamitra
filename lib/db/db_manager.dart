import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shabdamitra/db/synset.dart';
import 'package:shabdamitra/db/word.dart';
import 'package:sqflite/sqflite.dart';

class DbManager {
  late final Database _db;

  DbManager._internal() {
    getDatabasesPath().then((value) {
      String dbPath = join(value, "shabdamitra.db");

      databaseExists(dbPath).then((exists) {
        if (!exists) {
          try {
            Directory(dirname(dbPath)).create(recursive: true).then((value) {});
          } catch (_) {}
          rootBundle.load(join("assets", "shadbamitra.db")).then((data) {
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

            File(dbPath).writeAsBytesSync(bytes, flush: true);
          });
        }

        openDatabase(dbPath).then((db) {
          _db = db;
        });
      });
    });
  }

  static final DbManager _instance = DbManager._internal();

  factory DbManager() {
    return _instance;
  }

  Future<int> getWordId(String word) {
    return _db.rawQuery('SELECT word_id FROM tcp_word WHERE word = ?',
        [word]).then((list) => list[0]['word_id'] as int);
  }

  Future<String> getWordFromId(int id) {
    return _db.rawQuery('SELECT word FROM tcp_word WHERE word_id = ?',
        [id]).then((list) => list[0]['word'] as String);
  }

  Future<List<Map<String, Object?>>> getSynsets(int wordId) {
    return _db.rawQuery(
        'WITH synset_id(si) AS ( '
        'SELECT DISTINCT synset_id '
        'FROM tcp_synset_words WHERE word_id = ? '
        ') SELECT synset_id, concept_definition '
        'FROM synset_id INNER JOIN tcp_synset '
        'ON synset_id.si = tcp_synset.synset_id ',
        [wordId]);
  }

  Future<List<Map<String, Object?>>> getSynsetsForBoardAndStandard(
      int wordId, String board, int standard) {
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

  Future<String> getGender(int wordId, int synsetId) {
    return _db.rawQuery(
        'SELECT DISTINCT gender '
        'FROM tcp_synset_words '
        'WHERE word_id = ? AND synset_id = ? ',
        [wordId, synsetId]).then((list) => list[0]['gender'] as String);
  }

  Future<List<int>> getLessons(String board, int standard) {
    return _db.rawQuery(
        'SELECT DISTINCT lesson_id FROM tcp_word_collection '
        'WHERE board = ? AND class_id = ? ',
        [board, standard]).then((list) {
      return list.map((map) => map['lesson_id'] as int).toList();
    });
  }

  Future<List<Map<String, Object?>>> getLessonWords(String board, int standard, int lesson) {
    return _db.rawQuery(
        'WITH word_id(wi) AS ( '
        'SELECT word_id FROM tcp_word_collection '
        'WHERE board = ? AND class_id = ? AND lesson_id = ? '
        ') SELECT word_id, word '
        'FROM word_id INNER JOIN tcp_word '
        'ON word_id.wi = tcp_word.word_id ',
        [board, standard, lesson]);
  }
}
