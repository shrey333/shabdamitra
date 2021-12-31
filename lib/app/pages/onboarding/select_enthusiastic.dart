import 'package:flutter/material.dart';
import 'package:shabdamitra/app/pages/onboarding/SelectType.dart';

class SelectEnthusiastic extends StatefulWidget {
  const SelectEnthusiastic({Key? key}) : super(key: key);

  @override
  _SelectEnthusiasticState createState() => _SelectEnthusiasticState();
}

class _SelectEnthusiasticState extends State<SelectEnthusiastic> {
  int selectedIndex = 0;

  Widget customRadio(String text, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: (selectedIndex == index)
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
            selectedIndex = index;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: (selectedIndex == index) ? (Colors.blue) : (Colors.grey),
            fontWeight: (selectedIndex == index)
                ? (FontWeight.bold)
                : (FontWeight.normal),
          ),
        ),
      ),
    );
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
                      padding: EdgeInsets.all(20.0),
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
                height: MediaQuery.of(context).size.height * 0.70,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const SelectType(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
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
