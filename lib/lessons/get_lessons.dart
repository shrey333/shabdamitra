import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/db/lesson.dart';
import 'package:shabdamitra/lessons/word_lists.dart';

class GetLessons extends StatefulWidget {
  const GetLessons({Key? key}) : super(key: key);

  @override
  _GetLessonsState createState() => _GetLessonsState();
}

class _GetLessonsState extends State<GetLessons> {
  List<Lesson> lessons = <Lesson>[];

  _GetLessonsState() {
    ApplicationContext().dataManager.getLessons().then((value) => setState(() {
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
          if (lessons[index].lessonId <= 0) {
            return const SizedBox.shrink();
          }
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
                'Lesson ${lessons[index].lessonId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
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
}
