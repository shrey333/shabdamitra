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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: SizedBox(
                    height: 0.3 * _height,
                    width: _width,
                    child: Image.asset("assets/images/learn.png"),
                  ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: SizedBox(
                  height: 0.2 * _height,
                  width: _width,
                  child: Text(
                    "Learning words and grammar using images and audio",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 0.025 * _height,
                      color: Colors.black45,
                    ),
                  ),
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
