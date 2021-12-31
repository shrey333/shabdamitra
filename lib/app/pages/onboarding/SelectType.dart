import 'package:flutter/material.dart';
import 'package:shabdamitra/app/pages/onboarding/select_enthusiastic.dart';

class SelectType extends StatefulWidget {
  const SelectType({Key? key}) : super(key: key);

  @override
  _SelectTypeState createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  int selectedIndex = 0;
  List<String> images = [
    " ",
    "assets/images/student.png",
    "assets/images/enthusiastic.png",
  ];

  Widget customRadio(String text, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70,
      height: 150,
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: (selectedIndex == index)
            ? (Border.all(
                color: Colors.black,
                width: 3.0,
              ))
            : null,
      ),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                images[index],
                width: 100,
                height: 100,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: (selectedIndex == index) ? (Colors.blue) : (Colors.grey),
                fontWeight: (selectedIndex == index)
                    ? (FontWeight.bold)
                    : (FontWeight.normal),
              ),
            ),
          ],
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: const Center(
                        child: Text(
                          "I am a...",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    customRadio("Student", 1),
                    customRadio("Learner or enthusiastic", 2),
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
                              const SelectEnthusiastic(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                      //   MaterialPageRoute(
                      //       builder: (context) => const SelectEnthusiastic()),
                      // );
                    },
                    child: const Text(
                      ' N E X T ->',
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
