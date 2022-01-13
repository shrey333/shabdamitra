
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _userType = 0, _userBoard = 0, _userClass = 0, _userProficiency = 0;
  final GetStorage _storage = GetStorage();

  final List<S2Choice<int>> _userTypeList = [
    S2Choice(value: 0, title: 'Student'),
    S2Choice(value: 1, title: 'Enthusiastic'),
  ];
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
  final List<S2Choice<int>> _userProficiencyList = [
    S2Choice(value: 0, title: 'Beginner'),
    S2Choice(value: 1, title: 'Intermediate'),
    S2Choice(value: 2, title: 'Expert'),
  ];

  @override
  void initState() {
    super.initState();
    _userType = _storage.read("userType") ?? 0;
    _userBoard = _storage.read("userBoard") ?? 0;
    _userClass = _storage.read("userClass") ?? 0;
    _userProficiency = _storage.read("userProficiency") ?? 0;
  }

  void _saveToLocal(int _userDataType, int _userData) async {
    switch (_userDataType) {
      case 0:
        setState(() {
          _userType = _userData;
          _storage.write('userType', _userType);
        });
        
        break;
      case 1:
        setState(() {
          _userBoard = _userData;
          _storage.write('userBoard', _userBoard);
          if (_userBoard == 3) {
            _userClass = 4;
          } else {
            _userClass = 0;
          }
          _storage.write('userClass', _userClass);
        });
        break;
      case 2:
        setState(() {
          _userClass = _userData;
          _storage.write('userClass', _userClass);
        });
        break;
      case 3:
        setState(() {
          _userProficiency = _userData;
          _storage.write('userProficiency', _userProficiency);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SmartSelect<int>.single(
                title: "User type",
                selectedValue: _userType,
                choiceItems: _userTypeList,
                modalType: S2ModalType.bottomSheet,
                onChange: (state) => _saveToLocal(0, state.value!),
              ),
              SmartSelect<int>.single(
                title: "User board",
                selectedValue: _userBoard,
                choiceItems: _userBoardList,
                modalType: S2ModalType.bottomSheet,
                onChange: (state) => _saveToLocal(1, state.value!),
              ),
              SmartSelect<int>.single(
                title: "User class",
                selectedValue: _userClass,
                choiceItems: _userClassList[_userBoard],
                modalType: S2ModalType.bottomSheet,
                onChange: (state) => _saveToLocal(2, state.value!),
              ),
              SmartSelect<int>.single(
                title: "User Proficiency",
                selectedValue: _userProficiency,
                choiceItems: _userProficiencyList,
                modalType: S2ModalType.bottomSheet,
                onChange: (state) => _saveToLocal(3, state.value!),
              ),
            ],
          ),
      ),
    );
  }
}
