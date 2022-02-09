import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/homepage.dart';

class SelectProficiency extends StatefulWidget {
  const SelectProficiency({Key? key}) : super(key: key);

  @override
  _SelectProficiencyState createState() => _SelectProficiencyState();
}

class _SelectProficiencyState extends State<SelectProficiency> {
  int _selectedIndex = 0;
  final GetStorage _storage = GetStorage();

  Widget customRadio(String text, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70,
      height: MediaQuery.of(context).size.height * 0.099,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: (_selectedIndex == index)
            ? (Border.all(
                color: Colors.black,
                width: 3.0,
              ))
            : null,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AutoSizeText(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (_selectedIndex == index) ? (Colors.blue) : (Colors.grey),
            fontWeight: (_selectedIndex == index)
                ? (FontWeight.bold)
                : (FontWeight.normal),
          ),
        ),
      ),
    );
  }

  void _onFinish() async {
    if (_selectedIndex == 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Proficiency level is missing!!!'),
          content: const Text(
              'Proficiency is required because you will be shown words based open it.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay '),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    } else {
      _storage.write('userProficiency', _selectedIndex - 1);
      _storage.write('userBoard', 0);
      _storage.write('userClass', 0);
      Get.offAll(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _inset = 0.01 * _height;
    _width = _width - 2 * _inset;
    _height = _height - 2 * _inset;
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(_inset),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: AutoSizeText(
                    "Tell us about you",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: const AutoSizeText(
                        "How familiar are you with Hindi?",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: const AutoSizeText(
                        "Dictate the information that will be shown.",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    customRadio("Beginner", 1),
                    customRadio("Intermediate", 2),
                    customRadio("Expert", 3),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: _height * 0.15,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _onFinish,
                    child: const AutoSizeText(
                      ' F I N I S H !',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
