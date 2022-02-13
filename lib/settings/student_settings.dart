import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/choices.dart';

class StudentSettings extends StatefulWidget {
  const StudentSettings({Key? key}) : super(key: key);

  @override
  _StudentSettingsState createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  final ClassForReference _userClass = ClassForReference(0),
      _userBoard = ClassForReference(0);
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _userBoard.value = _storage.read("userBoard") ?? 0;
    _userClass.value = _storage.read("userClass") ?? 0;
  }

  void _saveToLocal() {
    _storage.write("userBoard", _userBoard.value);
    _storage.write("userClass", _userClass.value);
  }

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
                CustomSettingsTile(
                  child: Center(
                    child: ListTile(
                      title: const Text("User Class"),
                      subtitle: Text(
                          userClassList[_userBoard.value][_userClass.value]),
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
          ],
        ),
      ),
    );
  }
}
