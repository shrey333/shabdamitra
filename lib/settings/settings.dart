import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/choices.dart' as choice;
import 'package:shabdamitra/settings/student_settings.dart';
import 'package:shabdamitra/settings/learner_settings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _userType = 0, _userBoard = 0, _userClass = 0, _userProficiency = 0, _language = 0;
  final GetStorage _storage = GetStorage();
  String _theme = 'Blue';

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

  _onTap() {
    showDialog(
        context: context,
        builder: (_) =>
          AlertDialog(
            title: const Text("Are you Sure?"),
            content: const Text("You will lose all data pertaining to the selected type."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')
              ),
              ElevatedButton(
                onPressed: () {
                  _userType == 0 ? _saveToLocal(0, 1) : _saveToLocal(0, 0);
                  Navigator.of(context).pop();
                },
                child: const Text('Okay ',)
              )
            ],
          )
    );
    setState(() {});
  }

  _createRouteStudent() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const StudentSettings(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  _createRouteLearner() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LearnerSettings(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  _getUserTypeSettings() {
    return SettingsSection(
      title: const Text('User Settings'),
      tiles: [
        CustomSettingsTile(
          child: ListTile(
            leading: const Icon(Icons.menu),
            trailing: const Icon(Icons.keyboard_arrow_right),
            title: Text(_userType == 0 ? 'Student Settings' : 'Learner Settings'),
            subtitle: const Text('Customize your preferences'),
            onTap: () {
              _userType == 0
                  ? Navigator.of(context).push(_createRouteStudent())
                  : Navigator.of(context).push(_createRouteLearner());
            }
          )
        ),
        CustomSettingsTile(
          child: ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(_userType == 0 ? 'You are Currently a Student' : 'You are Currently a Learner'),
            subtitle: Text(_userType == 0 ? 'Tap to Switch to Learner' : 'Tap to Switch to Student'),
            onTap: _onTap,
          ),
        ),

      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              CustomSettingsTile(
                child: SmartSelect<int>.single(
                  title: 'Language',
                  selectedValue: _language,
                  choiceItems: choice.languageList,
                  modalType: S2ModalType.bottomSheet,
                  onChange: (state) => _saveToLocal(4, state.value!),
                  tileBuilder: (context, state) {
                    return S2Tile.fromState(state, isTwoLine: true, leading: const Icon(Icons.language_sharp),);
                  },
                )
              ),
              CustomSettingsTile(
                child: SmartSelect<String>.single(
                  title: 'Theme',
                  selectedValue: _theme,
                  choiceItems: choice.themeList,
                  modalType: S2ModalType.bottomSheet,
                  onChange: (selected) => setState(() => _theme = selected.value!),
                  tileBuilder: (context, state) {
                    return S2Tile.fromState(state, isTwoLine: true, leading: const Icon(Icons.format_paint),);
                  },
                ),
              ),
              CustomSettingsTile(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('About the Developers'),
                  subtitle: const Text('Know more about us'),
                  onTap: (){},
                ),
              ),
              CustomSettingsTile(
                child: ListTile(
                  leading: const Icon(Icons.support_agent),
                  title: const Text('Help'),
                  subtitle: const Text('Get our Help'),
                  onTap: (){},
                ),
              ),
            ],
          ),
          _getUserTypeSettings(),
          const CustomSettingsSection(child: CustomSettingsTile(child: SizedBox(height: 30,),))
        ],
      )
    );
  }
}
