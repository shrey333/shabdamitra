import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/homepage.dart';
import 'package:shabdamitra/choices.dart' as choice;

class SelectStudentDetails extends StatefulWidget {
  const SelectStudentDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectStudentDetailsState();
}

class _SelectStudentDetailsState extends State<SelectStudentDetails> {
  int _userClass = 0, _userBoard = 0;
  final GetStorage _storage = GetStorage();

  void _saveToLocal(int _userDataType, int _userData) async {
    switch (_userDataType) {
      case 1:
        setState(() {
          _userBoard = _userData;
          _storage.write('userBoard', _userBoard);
          if (_userBoard == 3) {
            _userClass = 4;
          } else {
            _userClass = 0;
          }
        });
        break;
      case 2:
        setState(() {
          _userClass = _userData;
          _storage.write('userClass', _userClass);
        });
        break;
    }
  }

  void _onFinish() {
    _storage.write('userProficiency', 0);
    _storage.write('userBoard', _userBoard);
    _storage.write('userClass', _userClass);
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
                        child: SmartSelect<int>.single(
                          title: 'User Board',
                          selectedValue: _userBoard,
                          choiceItems: choice.userBoardList,
                          onChange: (state) => _saveToLocal(1, state.value!),
                          modalType: S2ModalType.bottomSheet,
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
                        child: SmartSelect<int>.single(
                          title: "User class",
                          selectedValue: _userClass,
                          choiceItems: choice.userClassList[_userBoard],
                          modalType: S2ModalType.bottomSheet,
                          onChange: (state) => _saveToLocal(2, state.value!),
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
