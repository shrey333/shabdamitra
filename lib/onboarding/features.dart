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
    double width = 0.6 * MediaQuery.of(context).size.width / 3;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 3,
                    child: Image.asset('assets/images/learn.png'),
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Image.asset(
                            'assets/images/image.png',
                            width: width,
                            height: width,
                          ),
                        ),
                        Flexible(
                          child: Image.asset(
                            'assets/images/audio.png',
                            width: width,
                            height: width,
                          ),
                        ),
                        Flexible(
                          child: Image.asset(
                            'assets/images/grammar.png',
                            width: width,
                            height: width,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Flexible(
                    flex: 1,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: AutoSizeText(
                        'Learning words and grammar using images and audio',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
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
