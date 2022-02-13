import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/choices.dart';
import 'package:shabdamitra/homepage.dart';

class SelectStudentDetails extends StatefulWidget {
  const SelectStudentDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectStudentDetailsState();
}

class _SelectStudentDetailsState extends State<SelectStudentDetails> {
  final ClassForReference _userClass = ClassForReference(0),
      _userBoard = ClassForReference(0);
  final GetStorage _storage = GetStorage();

  void showPicker(
    BuildContext _context,
    List<String> _list,
    ClassForReference _intialIndex,
    String _title,
    int _dataType,
  ) {
    int _selectedIndex = _intialIndex.value;
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
                      _title,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        setState(
                          () {
                            if (_dataType == 0) {
                              _userClass.value = 0;
                            }
                            _intialIndex.value = _selectedIndex;
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
                  scrollController:
                      FixedExtentScrollController(initialItem: _selectedIndex),
                  magnification: 1.2,
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(
                      () {
                        _selectedIndex = index;
                      },
                    );
                  },
                  children: _list.map(
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

  void _onFinish() {
    _storage.write('userProficiency', 0);
    _storage.write('userBoard', _userBoard.value);
    _storage.write('userClass', _userClass.value);
    _storage.write('onboardingDone', true);
    Get.offAll(() => const HomePage());
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
                          subtitle: Text(userBoardList[_userBoard.value]),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showPicker(
                              context,
                              userBoardList,
                              _userBoard,
                              "User Board",
                              0,
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
                          subtitle: Text(userClassList[_userBoard.value]
                              [_userClass.value]),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showPicker(
                              context,
                              userClassList[_userBoard.value],
                              _userClass,
                              "User Class",
                              1,
                            );
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
                    onPressed: _onFinish,
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
