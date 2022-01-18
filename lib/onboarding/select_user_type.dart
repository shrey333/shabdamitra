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
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: (_selectedIndex == index)
            ? (Border.all(
                color: Colors.black,
                width: 3.0,
              ))
            : null,
      ),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
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
              Text(
                text,
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
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      _storage.write('userType', _selectedIndex - 1);
      if (_selectedIndex == 1) {
        Get.to(const SelectStudentDetails());
      }else if(_selectedIndex == 2){
        Get.to(const SelectProficiency());
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(35.0),
                      child: Text(
                        "Tell us about you",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: const Center(
                        child: Text(
                          "I am a...",
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
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: _onNext,
                    child: const Text(
                      ' N E X T ->',
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
