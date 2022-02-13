import 'package:flutter/material.dart';
import 'dart:math';

class Tests extends StatefulWidget {
  const Tests({Key? key}) : super(key: key);
  @override
  _TestsState createState() => _TestsState();
}

class _TestsState extends State<Tests> {
  _getRandomValue(int min, int max) {
    final _random = Random();
    var a = min + _random.nextDouble() * (max - min);
    return a;
  }

  _getColor(_val) {
    if (_val <= 0.3) {
      return const AlwaysStoppedAnimation<Color>(Colors.red);
    } else if (_val > 0.3 && _val <= 0.7) {
      return const AlwaysStoppedAnimation<Color>(Colors.yellow);
    } else {
      return const AlwaysStoppedAnimation<Color>(Colors.green);
    }
  }

  _getEval(_val) {
    if (_val <= 0.3) {
      return const Text(" Try Again!!");
    } else if (_val > 0.3 && _val <= 0.7) {
      return const Text(" Passed");
    } else {
      return const Text(" Excelsior!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                "Test ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: <Widget>[
                  //Icon(Icons.linear_scale, color: Colors.yellowAccent),
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                      child: LinearProgressIndicator(
                        valueColor: _getColor(_val),
                        backgroundColor: const Color(0xffD6D6D6),
                        value: _val,
                      ),
                    ),
                    width: 30,
                    height: 5,
                  ),
                  _getEval(_val)
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {},
            ),
          );
        });
  }
}
