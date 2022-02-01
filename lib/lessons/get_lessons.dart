import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/lessons/word_lists.dart';

class GetLessons extends StatefulWidget {
  const GetLessons({Key? key}) : super(key: key);

  @override
  _GetLessonsState createState() => _GetLessonsState();
}

class _GetLessonsState extends State<GetLessons> {

  _getRandomValue(int min, int max){
    final _random = Random();
    var a = min + _random.nextDouble()*(max - min);
    return a;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          var _val = _getRandomValue(0, 1);
          var _per = _val * 100;
          var _rnd = _per.round();
          _per = _rnd;
          _val = _per / 100;
          return Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Container(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Container(
                  padding: const EdgeInsets.only(right: 12.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 1.0, color: Colors.black26)
                    )
                  ),
                  child: const Icon(Icons.analytics),
                ),
                title: Text(
                  "Lesson ${index+1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: <Widget>[
                    //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        child: LinearProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          backgroundColor: const Color(0xffD6D6D6),
                          value: _val,
                        ),
                      ),
                      width: 30,
                      height: 5,
                    ),
                    _val < 1 ? Text(' Progress $_per%') : const Text(' Completed 100%')
                  ],
                ),
                trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WordLists()));
                },
              ),
              ),
            );
          }
      ),
    );
  }
}
