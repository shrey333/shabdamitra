// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/enums.dart';
import 'package:shabdamitra/util/user_property_value_picker.dart';

class UserSettings extends StatefulWidget {
  final UserType userType;
  const UserSettings({Key? key, required this.userType}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState(userType);
}

class _UserSettingsState extends State<UserSettings> {
  final UserType userType;
  _UserSettingsState(this.userType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getSettingsTitle(userType)),
      ),
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                CustomSettingsTile(
                  child: Center(
                    child: UserPropertyValuePicker(
                      userType: userType,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
