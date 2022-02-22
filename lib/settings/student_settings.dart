import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/util/user_property.dart';

class StudentSettings extends StatefulWidget {
  const StudentSettings({Key? key}) : super(key: key);

  @override
  _StudentSettingsState createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  void showPicker(BuildContext _context, UserProperty studentProperty) {
    int studentBoardIndex = ApplicationContext().getStudentBoardIndex();
    int studentStandardIndex = ApplicationContext().getStudentStandardIndex();
    String title;
    List<String> propertyValues;
    int propertyValueIndex;
    if (studentProperty == UserProperty.studentBoard) {
      title = "Student Board";
      propertyValues = ApplicationContext.StudentBoards;
      propertyValueIndex = studentBoardIndex;
    } else {
      title = "Student Standard";
      propertyValues = ApplicationContext
          .StudentBoardsAndStandards[ApplicationContext().getStudentBoard()]!
          .map((standard) => ApplicationContext.toStandardString(standard))
          .toList();
      propertyValueIndex = studentStandardIndex;
    }

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
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        setState(
                          () {
                            if (studentProperty == UserProperty.studentBoard) {
                              studentBoardIndex = propertyValueIndex;
                              studentStandardIndex = ApplicationContext.defaultStudentStandardIndex;
                            } else {
                              studentStandardIndex = propertyValueIndex;
                            }
                            ApplicationContext().setUserTypeStudent(
                                studentBoardIndex, studentStandardIndex);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Settings"),
      ),
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Student Settings'),
              tiles: [
                CustomSettingsTile(
                  child: Center(
                    child: ListTile(
                      title: const Text("Student Board"),
                      subtitle: Text(ApplicationContext().getStudentBoard()),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showPicker(
                          context,
                          UserProperty.studentBoard,
                        );
                      },
                    ),
                  ),
                ),
                CustomSettingsTile(
                  child: Center(
                    child: ListTile(
                      title: const Text("Student Standard"),
                      subtitle: Text(
                          ApplicationContext().getStudentStandard().toString()),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showPicker(
                          context,
                          UserProperty.studentStandard,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
