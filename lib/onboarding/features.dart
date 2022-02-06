import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/onboarding/select_user_type.dart';

class Features extends StatelessWidget {
  const Features({Key? key}) : super(key: key);

  _onNext() {
    Get.to(() => const SelectUserType());
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Image.asset('assets/images/learn.png'),
                  ),
                  Row(
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
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    child: AutoSizeText(
                      "Learning words and grammar using images and audio",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 0.15 * _height,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: _onNext,
                  child: const AutoSizeText(
                    ' N E X T ->',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
