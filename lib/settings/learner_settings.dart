import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/choices.dart' as choice;

class LearnerSettings extends StatefulWidget {
  const LearnerSettings({Key? key}) : super(key: key);

  @override
  _LearnerSettingsState createState() => _LearnerSettingsState();
}

class _LearnerSettingsState extends State<LearnerSettings> {
  int _userType = 0,
      _userBoard = 0,
      _userClass = 0,
      _userProficiency = 0,
      _language = 0;
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _userType = _storage.read("userType") ?? 0;
    _userBoard = _storage.read("userBoard") ?? 0;
    _userClass = _storage.read("userClass") ?? 0;
    _userProficiency = _storage.read("userProficiency") ?? 0;
    _language = _storage.read('language') ?? 0;
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
      case 4:
        setState(() {
          _language = _userData;
          _storage.write('language', _language);
        });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SettingsList(sections: [
          SettingsSection(title: const Text('Learner Settings'), tiles: [
            CustomSettingsTile(
              child: SmartSelect<int>.single(
                title: "Proficiency Level",
                selectedValue: _userProficiency,
                choiceItems: choice.userProficiencyList,
                modalType: S2ModalType.bottomSheet,
                onChange: (state) => _saveToLocal(3, state.value!),
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    isTwoLine: true,
                    leading: const CircleAvatar(
                      child: Icon(Icons.sort),
                    ),
                  );
                },
              ),
            )
          ])
        ]),
      ),
    );
  }
}
