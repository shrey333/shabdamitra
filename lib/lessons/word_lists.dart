import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/ErrorHandlers/error.dart';
import 'package:shabdamitra/db/lesson.dart';
import 'package:shabdamitra/db/word_synset.dart';
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

  _WordListsState(this.lesson);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson ' + lesson.lessonId.toString()),
      ),
      body: FutureBuilder<List<WordSynset>>(
        future: lesson.getLessonWordSynsets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const ErrorRoute();
          }
          if (snapshot.hasData) {
            List<WordSynset> lessonWordSynsets = snapshot.data!;
            return ListView.builder(
              itemCount: lessonWordSynsets.length,
              itemBuilder: (context, index) {
                return Container(
                  child: ListTile(
                    minVerticalPadding: 10,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade500,
                      child: Text(lessonWordSynsets[index].word.word[0]),
                    ),
                    title: Text(lessonWordSynsets[index].word.word),
                    onTap: () {
                      Get.to(() => WordDisplay(
                            wordSynsets: lessonWordSynsets,
                            initialWordSynset: index,
                          ));
                    },
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                );
              },
            );
          }
          return const Center(
            child: Text('No words found.'),
          );
        },
      ),
    );
  }
}
