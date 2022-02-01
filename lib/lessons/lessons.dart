import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/lessons/get_lessons.dart';
import 'package:shabdamitra/lessons/progress.dart';
import 'package:shabdamitra/lessons/tests.dart';
import 'package:shabdamitra/lessons/word_lists.dart';

class Lessons extends StatefulWidget {
  const Lessons({Key? key}) : super(key: key);

  @override
  _LessonsState createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                tabs: [
                  Tab(
                    text: 'Lessons',
                  ),
                  Tab(
                    text: 'Tests',
                  ),
                  Tab(
                    text: 'Progress',
                  ),
                ],
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GetLessons(),
            Tests(),
            Progress(),
          ],
        ),
      ),
    );
  }
}
