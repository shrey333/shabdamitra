// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/enums.dart';
import 'package:shabdamitra/settings/user_settings.dart';

class Settings extends StatefulWidget {
  final void Function() onChange;
  const Settings({Key? key, required this.onChange}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState(onChange);
}

class _SettingsState extends State<Settings> {
  final void Function() onChange;
  _SettingsState(this.onChange);

  _onTap() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Are you sure?"),
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
                  if (ApplicationContext().isUserStudent()) {
                    ApplicationContext().setUserTypeLearnerWithDefaultValues();
                  } else {
                    ApplicationContext().setUserTypeStudentWithDefaultValues();
                  }
                },
              );
              onChange();
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

  @override
  Widget build(BuildContext context) {
    UserType userType;
    UserType changeToType;
    if (ApplicationContext().isUserStudent()) {
      userType = UserType.student;
      changeToType = UserType.learner;
    } else {
      userType = UserType.learner;
      changeToType = UserType.student;
    }
    return SafeArea(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('User Settings'),
            tiles: [
              CustomSettingsTile(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.menu),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  title: Text(getSettingsTitle(userType)),
                  subtitle: const Text('Customize your preferences'),
                  onTap: () {
                    Get.to(
                      () => UserSettings(
                        userType: userType,
                      ),
                    );
                  },
                ),
              ),
              CustomSettingsTile(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.swap_horiz)),
                  title:
                      Text('You are currently a ${userTypeToString(userType)}'),
                  subtitle: Text(
                      'Tap to switch to ${userTypeToString(changeToType)}'),
                  onTap: _onTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
