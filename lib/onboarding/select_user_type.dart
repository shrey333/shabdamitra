import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/onboarding/select_proficiency.dart';
import 'package:shabdamitra/onboarding/select_student_details.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({Key? key}) : super(key: key);

  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  int _selectedIndex = 0;
  final GetStorage _storage = GetStorage();

  List<String> images = [
    " ",
    "assets/images/student.png",
    "assets/images/enthusiastic.png",
  ];

  Widget customRadio(String text, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: (_selectedIndex == index)
            ? Border.all(
                color: Colors.black,
                width: 3.0,
              )
            : null,
      ),
      child: OutlinedButton(
        onPressed: () {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Image.asset(
                images[index],
                width: MediaQuery.of(context).size.width * 0.14,
                height: MediaQuery.of(context).size.height * 0.14,
              ),
              AutoSizeText(
                text,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      (_selectedIndex == index) ? (Colors.blue) : (Colors.grey),
                  fontWeight: (_selectedIndex == index)
                      ? (FontWeight.bold)
                      : (FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNext() async {
    if (_selectedIndex == 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('User type is missing!!!'),
          content:
              const Text('User type is required to determine your interests.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay '),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    } else {
      _storage.write('userType', _selectedIndex - 1);
      if (_selectedIndex == 1) {
        Get.to(() => const SelectStudentDetails());
      } else if (_selectedIndex == 2) {
        Get.to(() => const SelectProficiency());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _inset = 0.01 * _height;
    _width = _width - 2 * _inset;
    _height = _height - 2 * _inset;
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(_inset),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: AutoSizeText(
                    "Tell us about you",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: const Center(
                        child: AutoSizeText(
                          "I am a...",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    customRadio("Student", 1),
                    customRadio("Learner or enthusiastic", 2),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 0.15 * _height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _onNext,
                    child: const AutoSizeText(
                      ' N E X T ->',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
