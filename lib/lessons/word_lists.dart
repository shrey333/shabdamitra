import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/db/lesson.dart';
import 'package:shabdamitra/db/word.dart';
import 'package:shabdamitra/word/word_display.dart';

class WordLists extends StatefulWidget {
  final Lesson lesson;
  const WordLists({Key? key, required this.lesson}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _WordListsState createState() => _WordListsState(lesson);
}

class _WordListsState extends State<WordLists> {
  final Lesson lesson;
  List<Word> words = <Word>[];

  _WordListsState(this.lesson) {
    lesson.words.then((value) => setState(() {
          words = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Lists"),
      ),
      body: words.isEmpty
          ? Center(
              child: SizedBox(
                child: const CircularProgressIndicator(),
                height: context.mediaQuery.size.height * 0.05,
              ),
            )
          : ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Container(
                  child: ListTile(
                    minVerticalPadding: 10,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade500,
                      child: Text(words[index].word[0]),
                    ),
                    title: Text(words[index].word),
                    onTap: () {
                      Get.to(() => WordDisplay(
                            word: words[index],
                            index: 0,
                          ));
                    },
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                );
              },
            ),
    );
  }
}
