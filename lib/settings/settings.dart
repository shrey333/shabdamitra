import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/choices.dart';
import 'package:shabdamitra/settings/student_settings.dart';
import 'package:shabdamitra/settings/learner_settings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final ClassForReference _userLanguage = ClassForReference(0),
      _userTheme = ClassForReference(0);
  int _userType = 0;
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _userType = _storage.read("userType") ?? 0;
    _userLanguage.value = _storage.read('language') ?? 0;
    _userTheme.value = _storage.read('theme') ?? 0;
  }

  void _saveToLocal() {
    _storage.write('userType', _userType);
    _storage.write('language', _userLanguage.value);
    _storage.write('theme', _userTheme.value);
  }

  _onTap() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Are you Sure?"),
        content: const Text(
            "You will lose all data pertaining to the selected type."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                () {
                  _userType = (_userType == 1) ? 0 : 1;
                  _saveToLocal();
                },
              );
              Get.back();
            },
            child: const Text(
              'Okay ',
            ),
          ),
        ],
      ),
    );
    setState(() {});
  }

  _getUserTypeSettings() {
    return SettingsSection(
      title: const Text('User Settings'),
      tiles: [
        CustomSettingsTile(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.menu),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            title:
                Text(_userType == 0 ? 'Student Settings' : 'Learner Settings'),
            subtitle: const Text('Customize your preferences'),
            onTap: () {
              _userType == 0
                  ? Get.to(() => const StudentSettings())
                  : Get.to(() => const LearnerSettings());
            },
          ),
        ),
        CustomSettingsTile(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.swap_horiz)),
            title: Text(_userType == 0
                ? 'You are Currently a Student'
                : 'You are Currently a Learner'),
            subtitle: Text(_userType == 0
                ? 'Tap to Switch to Learner'
                : 'Tap to Switch to Student'),
            onTap: _onTap,
          ),
        ),
      ],
    );
  }

  void showPicker(
    BuildContext _context,
    List<String> _list,
    ClassForReference _intialIndex,
    String _title,
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
                            _intialIndex.value = _selectedIndex;
                            _saveToLocal();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              CustomSettingsTile(
                child: Center(
                  child: ListTile(
                    title: const Text("User Language"),
                    leading: const CircleAvatar(
                      child: Icon(Icons.language),
                    ),
                    subtitle: Text(
                      userLanguageList[_userLanguage.value],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      showPicker(
                        context,
                        userLanguageList,
                        _userLanguage,
                        "User Language",
                      );
                    },
                  ),
                ),
              ),
              CustomSettingsTile(
                child: Center(
                  child: ListTile(
                    title: const Text("User Theme"),
                    leading: const CircleAvatar(
                      child: Icon(Icons.format_paint),
                    ),
                    subtitle: Text(
                      userThemeList[_userTheme.value],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      showPicker(
                        context,
                        userThemeList,
                        _userTheme,
                        "User Theme",
                      );
                    },
                  ),
                ),
              ),
              CustomSettingsTile(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: const Text('About the Developers'),
                  subtitle: const Text('Know more about us'),
                  onTap: () {},
                ),
              ),
              CustomSettingsTile(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.support_agent),
                  ),
                  title: const Text('Help'),
                  subtitle: const Text('Get our Help'),
                  onTap: () {},
                ),
              ),
            ],
          ),
          _getUserTypeSettings(),
          const CustomSettingsSection(
            child: CustomSettingsTile(
              child: SizedBox(
                height: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
