import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/homepage.dart';

class SelectStudentDetails extends StatefulWidget {
  const SelectStudentDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectStudentDetailsState();
}

class _SelectStudentDetailsState extends State<SelectStudentDetails> {
  int _userClass = 0, _userBoard = 0  ;
  final GetStorage _storage = GetStorage();

  final List<S2Choice<int>> _userBoardList = [
    S2Choice(value: 0, title: 'CBSE'),
    S2Choice(value: 1, title: 'SWDHAYAY'),
    S2Choice(value: 2, title: 'ICSE'),
    S2Choice(value: 3, title: 'MSBSHSE'),
  ];
  final List<List<S2Choice<int>>> _userClassList = [
    [
      S2Choice(value: 0, title: 'Class 1'),
      S2Choice(value: 1, title: 'Class 2'),
      S2Choice(value: 2, title: 'Class 3'),
      S2Choice(value: 3, title: 'Class 4'),
      S2Choice(value: 4, title: 'Class 5'),
      S2Choice(value: 5, title: 'Class 6'),
      S2Choice(value: 6, title: 'Class 7'),
      S2Choice(value: 7, title: 'Class 8'),
      S2Choice(value: 8, title: 'Class 9'),
      S2Choice(value: 9, title: 'Class 10'),
      S2Choice(value: 10, title: 'Class 11'),
    ],
    [
      S2Choice(value: 0, title: 'Class 1'),
    ],
    [
      S2Choice(value: 0, title: 'Class 1'),
      S2Choice(value: 1, title: 'Class 2'),
    ],
    [
      S2Choice(value: 4, title: 'Class 5'),
    ]
  ];

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
    Get.offAll(const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: _width,
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
                height: _height * 0.5,
                width: _width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: const Center(
                        child: Text(
                          "I am a Student of...",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SmartSelect<int>.single(
                      title: 'User Board',
                      selectedValue: _userBoard,
                      choiceItems: _userBoardList,
                      onChange: (state) => _saveToLocal(1, state.value!),
                      modalType: S2ModalType.bottomSheet,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(),
                    ),
                    SmartSelect<int>.single(
                      title: "User class",
                      selectedValue: _userClass,
                      choiceItems: _userClassList[_userBoard],
                      modalType: S2ModalType.bottomSheet,
                      onChange: (state) => _saveToLocal(2, state.value!),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: _onFinish,
                    child: const Text(
                      ' F I N I S H !',
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
