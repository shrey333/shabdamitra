import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/enums.dart';
import 'package:shabdamitra/onboarding/select_user_details.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({Key? key}) : super(key: key);

  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  int _selectedIndex = 0;

  List<String> images = [
    " ",
    "assets/images/student.png",
    "assets/images/enthusiastic.png",
  ];

  Widget customRadio(String text, int index) {
    return Flexible(
      flex: 2,
      child: Container(
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
                    color: (_selectedIndex == index)
                        ? (Colors.blue)
                        : (Colors.grey),
                    fontWeight: (_selectedIndex == index)
                        ? (FontWeight.bold)
                        : (FontWeight.normal),
                  ),
                ),
              ],
            ),
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
      UserType userType = UserType.student;
      if (_selectedIndex == 1) {
        userType = UserType.student;
      } else if (_selectedIndex == 2) {
        userType = UserType.learner;
      }
      ApplicationContext().unsetOnboardingDone();
      ApplicationContext().unsetUserTypeStudent();
      ApplicationContext().unsetUserTypeLearner();
      Get.to(() => SelectUserDetails(
            userType: userType,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                flex: 1,
                child: Padding(
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
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
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
                    ),
                    customRadio("Student", 1),
                    customRadio("Learner", 2),
                  ],
                ),
              ),
              const Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 20.0,
                  ),
                  // child: ElevatedButton(
                  //   onPressed: _onNext,
                  //   child: const AutoSizeText(
                  //     ' N E X T ->',
                  //     textAlign: TextAlign.center,
                  //     maxLines: 1,
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _onNext,
          label: const Text("NEXT->")
      ),
    );
  }
}
