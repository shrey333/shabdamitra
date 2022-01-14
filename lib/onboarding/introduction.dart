import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/onboarding/features.dart';

class Introduction extends StatelessWidget {
  const Introduction({Key? key}) : super(key: key);

  _onNext() {
    Get.to(const Features());
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(35.0, 35.0, 35.0, 20.0),
                      child: Text(
                        "Shabdamitra",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                      child: Text(
                        "A digital learning aid for teaching and learning Hindi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  height: 0.4 * _height,
                  width: _width,
                  child: Image.asset("assets/images/teaching.png"),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: _onNext,
                    child: const Text(
                      ' Get Started ! ->',
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
