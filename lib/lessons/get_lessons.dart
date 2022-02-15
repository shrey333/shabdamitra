import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/choices.dart';
import 'package:shabdamitra/db/data_manager.dart';
import 'package:shabdamitra/db/lesson.dart';
import 'package:shabdamitra/lessons/word_lists.dart';

class GetLessons extends StatefulWidget {
  const GetLessons({Key? key}) : super(key: key);

  @override
  _GetLessonsState createState() => _GetLessonsState();
}

class _GetLessonsState extends State<GetLessons> {
  List<Lesson> lessons = <Lesson>[];

  _getRandomValue(int min, int max) {
    final _random = Random();
    var a = min + _random.nextDouble() * (max - min);
    return a;
  }

  _GetLessonsState() {
    getLessons().then((value) => setState(() {
          lessons = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          var _val = _getRandomValue(0, 1);
          var _per = _val * 100;
          var _rnd = _per.round();
          _per = _rnd;
          _val = _per / 100;
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.book),
              ),
              title: Text(
                "Lesson ${lessons[index].lessonId}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: <Widget>[
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      child: LinearProgressIndicator(
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                        backgroundColor: const Color(0xffD6D6D6),
                        value: _val,
                      ),
                    ),
                    width: 30,
                    height: 5,
                  ),
                  _val < 1
                      ? Text(' Progress $_per%')
                      : const Text(' Completed 100%')
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                Get.to(() => WordLists(lesson: lessons[index]));
              },
            ),
          );
        });
  }

  Future<List<Lesson>> getLessons() {
    var storage = GetStorage();
    String board = userBoardList[storage.read('userBoard')];
    int standard = storage.read('userClass');
    var dataManager = DataManager.withHints(board, standard);
    return dataManager.getLessons();
  }
}
