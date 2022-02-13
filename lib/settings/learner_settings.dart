import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/choices.dart';

class LearnerSettings extends StatefulWidget {
  const LearnerSettings({Key? key}) : super(key: key);

  @override
  _LearnerSettingsState createState() => _LearnerSettingsState();
}

class _LearnerSettingsState extends State<LearnerSettings> {
  final ClassForReference _userProficiency = ClassForReference(0);
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _userProficiency.value = _storage.read("userProficiency") ?? 0;
  }

  void _saveToLocal() {
    _storage.write("userProficiency", _userProficiency.value);
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
                            _saveToLocal();
                            _intialIndex.value = _selectedIndex;
                          },
                        );
                        _saveToLocal();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learner Settings'),
      ),
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Learner Settings'),
              tiles: [
                CustomSettingsTile(
                  child: Center(
                    child: ListTile(
                      title: const Text("User Proficiency"),
                      subtitle: Text(
                        userProficiencyList[_userProficiency.value],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showPicker(
                          context,
                          userProficiencyList,
                          _userProficiency,
                          "User Proficiency",
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
