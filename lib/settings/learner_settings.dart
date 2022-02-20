import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shabdamitra/application_context.dart';

class LearnerSettings extends StatefulWidget {
  const LearnerSettings({Key? key}) : super(key: key);

  @override
  _LearnerSettingsState createState() => _LearnerSettingsState();
}

class _LearnerSettingsState extends State<LearnerSettings> {
  void showPicker(BuildContext _context) {
    int propertyValueIndex = ApplicationContext().getLearnerProficiencyIndex();
    String title = 'Learner Proficiency';

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
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        setState(
                          () {
                            ApplicationContext()
                                .setLearnerProficiencyIndex(propertyValueIndex);
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
                  scrollController: FixedExtentScrollController(
                      initialItem: propertyValueIndex),
                  magnification: 1.2,
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(
                      () {
                        propertyValueIndex = index;
                      },
                    );
                  },
                  children: ApplicationContext.LearnerProficiencies.map(
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
                      subtitle:
                          Text(ApplicationContext().getLearnerProficiency()),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        showPicker(
                          context,
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
