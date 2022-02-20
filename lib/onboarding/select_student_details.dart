import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/homepage.dart';
import 'package:shabdamitra/util/user_property.dart';

class SelectStudentDetails extends StatefulWidget {
  const SelectStudentDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectStudentDetailsState();
}

class _SelectStudentDetailsState extends State<SelectStudentDetails> {
  int studentBoardIndex = ApplicationContext.defaultStudentBoardIndex;
  int studentStandardIndex = ApplicationContext.defaultStudentStandardIndex;

  void showPicker(BuildContext _context, UserProperty studentProperty) {
    String title;
    List<dynamic> propertyValues;
    int propertyValueIndex;
    if (studentProperty == UserProperty.studentBoard) {
      title = "Student Board";
      propertyValues = ApplicationContext.StudentBoards;
      propertyValueIndex = studentBoardIndex;
    } else {
      title = "Student Standard";
      propertyValues = ApplicationContext
          .StudentBoardsAndStandards[ApplicationContext.StudentBoards[studentBoardIndex]]!;
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
                    (value) {
                      return Center(
                        child: Text(
                          value.toString(),
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
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _inset = 0.01 * _height;

    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(_inset),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: _width,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: AutoSizeText(
                    "Tell us about you",
                    maxLines: 1,
                    textAlign: TextAlign.center,
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
                          "I am a student of...",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      height: MediaQuery.of(context).size.height * 0.099,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          title: const Text("User Board"),
                          subtitle:
                              Text(ApplicationContext.getDefaultStudentBoard()),
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
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      height: MediaQuery.of(context).size.height * 0.099,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          title: const Text("User Class"),
                          subtitle: Text(ApplicationContext
                              .getDefaultStudentStandardString()),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showPicker(context, UserProperty.studentStandard);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 0.15 * _height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      ApplicationContext().setUserTypeStudent(
                          studentBoardIndex, studentStandardIndex);
                      Get.offAll(() => const HomePage());
                    },
                    child: const AutoSizeText(
                      ' F I N I S H !',
                      maxLines: 1,
                      textAlign: TextAlign.center,
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
