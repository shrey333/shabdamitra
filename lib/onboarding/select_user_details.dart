// ignore_for_file: no_logic_in_create_state

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/homepage.dart';
import 'package:shabdamitra/enums.dart';
import 'package:shabdamitra/util/user_property_value_picker.dart';

class SelectUserDetails extends StatefulWidget {
  final UserType userType;
  const SelectUserDetails({Key? key, required this.userType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectUserDetailsState(userType);
}

class _SelectUserDetailsState extends State<SelectUserDetails> {
  final UserType userType;
  final List<UserPropertyValuePicker> userPropertyValuePickers =
      <UserPropertyValuePicker>[];

  _SelectUserDetailsState(this.userType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: AutoSizeText(
                    "Tell us about you",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: userType == UserType.student ? 3 : 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: Center(
                          child: AutoSizeText(
                            getPrompt(userType),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: userType == UserType.student ? 2 : 1,
                      fit: FlexFit.tight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Center(
                          child: UserPropertyValuePicker(
                            userType: userType,
                          ),
                        ),
                      ),
                    ),
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
                  //   onPressed: () {
                  //     if (userType == UserType.student) {
                  //       ApplicationContext()
                  //           .setUserTypeStudentWithDefaultValues();
                  //     } else {
                  //       ApplicationContext()
                  //           .setUserTypeLearnerWithDefaultValues();
                  //     }
                  //     Get.offAll(() => const HomePage());
                  //   },
                  //   child: const AutoSizeText(
                  //     ' F I N I S H !',
                  //     maxLines: 1,
                  //     textAlign: TextAlign.center,
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
          onPressed: () {
            if (!ApplicationContext().isOnboardingDone()) {
              if (userType == UserType.student) {
                ApplicationContext()
                    .setUserTypeStudentWithDefaultValues();
              } else {
                ApplicationContext()
                    .setUserTypeLearnerWithDefaultValues();
              }
            }
            Get.offAll(() => const HomePage());
          },
          label: const Text("FINISH!")
      ),
    );
  }
}
