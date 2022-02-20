import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/settings/student_settings.dart';
import 'package:shabdamitra/settings/learner_settings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                  if (ApplicationContext().isUserStudent()) {
                    ApplicationContext().setUserTypeLearnerWithDefaultValues();
                  } else {
                    ApplicationContext().setUserTypeStudentWithDefaultValues();
                  }
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

  @override
  Widget build(BuildContext context) {
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
                title: Text(ApplicationContext().isUserStudent()
                    ? 'Student Settings'
                    : 'Learner Settings'),
                subtitle: const Text('Customize your preferences'),
                onTap: () {
                  ApplicationContext().isUserStudent()
                      ? Get.to(() => const StudentSettings())
                      : Get.to(() => const LearnerSettings());
                },
              ),
            ),
            CustomSettingsTile(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.swap_horiz)),
                title: Text(ApplicationContext().isUserStudent()
                    ? 'You are Currently a Student'
                    : 'You are Currently a Learner'),
                subtitle: Text(ApplicationContext().isUserStudent()
                    ? 'Tap to Switch to Learner'
                    : 'Tap to Switch to Student'),
                onTap: _onTap,
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
