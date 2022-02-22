// ignore_for_file: no_logic_in_create_state

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/enums.dart';
import 'package:shabdamitra/util/user_property.dart';

class UserPropertyValuePicker extends StatefulWidget {
  final UserType userType;
  const UserPropertyValuePicker({Key? key, required this.userType})
      : super(key: key);

  @override
  _UserPropertyValuePickerState createState() =>
      _UserPropertyValuePickerState(userType);
}

class _UserPropertyValuePickerState extends State<UserPropertyValuePicker> {
  final UserType userType;
  _UserPropertyValuePickerState(this.userType);

  void showPicker(BuildContext _context, UserProperty userProperty,
      List<String> propertyValues, int initialValueIndex) {
    int propertyValueIndex = initialValueIndex;
    showCupertinoModalPopup(
      context: _context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff999999),
                      width: 0.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Get.back();
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    ),
                    Text(
                      userPropertyToString(userProperty),
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        setState(
                          () {
                            if (userProperty == UserProperty.studentBoard) {
                              if (initialValueIndex != propertyValueIndex) {
                                ApplicationContext().setUserTypeStudent(
                                    propertyValueIndex,
                                    ApplicationContext
                                        .defaultStudentStandardIndex);
                              }
                            } else if (userProperty ==
                                UserProperty.studentStandard) {
                              ApplicationContext().setUserTypeStudent(
                                  ApplicationContext().isOnboardingDone()
                                      ? ApplicationContext()
                                          .getStudentBoardIndex()
                                      : ApplicationContext
                                          .defaultStudentBoardIndex,
                                  propertyValueIndex);
                            } else {
                              ApplicationContext()
                                  .setUserTypeLearner(propertyValueIndex);
                            }
                          },
                        );
                        Get.back();
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: Get.height * 0.4,
                color: const Color(0xfff7f7f7),
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: propertyValueIndex),
                  magnification: 1.2,
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(
                      () {
                        propertyValueIndex = index;
                      },
                    );
                  },
                  children: propertyValues.map(
                    (String value) {
                      return Center(
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Color(0xff333333),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userType == UserType.learner) {
      return ListTile(
        title: Text(userPropertyToString(UserProperty.learnerProficiency)),
        subtitle: Text(ApplicationContext().isOnboardingDone()
            ? ApplicationContext().getLearnerProficiency()
            : ApplicationContext.getDefaultLearnerProficiency()),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          showPicker(
              context,
              UserProperty.learnerProficiency,
              ApplicationContext.LearnerProficiencies,
              ApplicationContext().isOnboardingDone()
                  ? ApplicationContext().getLearnerProficiencyIndex()
                  : ApplicationContext.defaultLearnerProficiencyIndex);
        },
      );
    } else {
      return Column(
        children: [
          ListTile(
            title: Text(userPropertyToString(UserProperty.studentBoard)),
            subtitle: Text(ApplicationContext().isOnboardingDone()
                ? ApplicationContext().getStudentBoard()
                : ApplicationContext.getDefaultStudentBoard()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showPicker(
                  context,
                  UserProperty.studentBoard,
                  ApplicationContext.StudentBoards,
                  ApplicationContext().isOnboardingDone()
                      ? ApplicationContext().getStudentBoardIndex()
                      : ApplicationContext.defaultStudentBoardIndex);
            },
          ),
          ListTile(
            title: Text(userPropertyToString(UserProperty.studentStandard)),
            subtitle: Text(ApplicationContext().isOnboardingDone()
                ? ApplicationContext().getStudentStandardString()
                : ApplicationContext.getDefaultStudentStandardString()),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showPicker(
                  context,
                  UserProperty.studentStandard,
                  ApplicationContext.StudentBoardsAndStandards[
                          ApplicationContext().isOnboardingDone()
                              ? ApplicationContext().getStudentBoard()
                              : ApplicationContext.getDefaultStudentBoard()]!
                      .map((standard) =>
                          ApplicationContext.toStandardString(standard))
                      .toList(),
                  ApplicationContext().isOnboardingDone()
                      ? ApplicationContext().getStudentStandardIndex()
                      : ApplicationContext.defaultStudentStandardIndex);
            },
          ),
        ],
      );
    }
  }
}
