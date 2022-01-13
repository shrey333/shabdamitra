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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 0.1 * _height,
                  width: _width,
                  child: Text(
                    "Shabdamitra",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 0.07 * _height,
                      fontWeight: FontWeight.w400,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 0.1 * _height,
                  width: _width,
                  child: Text(
                    "A digital learning aid for teaching and learning Hindi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 0.025 * _height,
                      color: Colors.blue.shade400,
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 0.4 * _height,
                  width: _width,
                  child: Image.asset("assets/images/teaching.png"),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 0.1 * _height,
                    top: 0.18 * _height,
                  ),
                  child: ElevatedButton(
                    onPressed: _onNext,
                    child: Text(
                      ' N E X T ->',
                      style: TextStyle(
                        fontSize: 0.03 * _height,
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
