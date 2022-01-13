import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/homepage.dart';

class SelectProficiancy extends StatefulWidget {
  const SelectProficiancy({Key? key}) : super(key: key);

  @override
  _SelectProficiancyState createState() => _SelectProficiancyState();
}

class _SelectProficiancyState extends State<SelectProficiancy> {
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
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Text(
          text,
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
    if(_selectedIndex == 0){
      showDialog(context: context
      , builder: (_) =>  AlertDialog(
            title: const Text('Proficiancy level is missing!!!'),
            content: const Text('Proficiency is required because you will be shown words based open it.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay '),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
        ),
      );
    }
    else{
      _storage.write('userProficiency', _selectedIndex - 1);
      _storage.write('userBoard', 0);
      _storage.write('userClass', 0);
      Get.offAll(const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(35.0),
                      child: Text(
                        "Tell us about you",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 5),
                      child: const Center(
                        child: Text(
                          "How familiar are you with Hindi?",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: const Center(
                        child: Text(
                          "Dictate the information that will be shown.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),
                    customRadio("Beginner", 1),
                    customRadio("Proficient", 2),
                    customRadio("Expert", 3),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: _onFinish,
                    child: const Text(
                      ' F I N I S H !',
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
