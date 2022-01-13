import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/onboarding/select_user_type.dart';

class Features extends StatelessWidget {
  const Features({Key? key}) : super(key: key);

  _onNext() {
    Get.to(const SelectUserType());
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
                  height: 0.3 * _height,
                  width: _width,
                  child: Image.asset("assets/images/learn.png"),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 0.15 * _height,
                  width: _width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 0.07 * _height,
                        width: 0.15 * _width,
                        child: Image.asset("assets/images/image.png"),
                      ),
                      SizedBox(
                        height: 0.07 * _height,
                        width: 0.15 * _width,
                        child: Image.asset("assets/images/audio.png"),
                      ),
                      SizedBox(
                        height: 0.07 * _height,
                        width: 0.15 * _width,
                        child: Image.asset("assets/images/grammar.png"),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 0.2 * _height,
                  width: _width,
                  child: Text(
                    "Learning words and grammar using images and audio",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 0.025 * _height,
                      color: Colors.blue.shade400,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 0.1 * _height,
                    top: 0.13 * _height,
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
