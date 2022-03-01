import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shabdamitra/onboarding/features.dart';

class Introduction extends StatelessWidget {
  const Introduction({Key? key}) : super(key: key);

  _onNext() {
    Get.to(() => const Features());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                        child: AutoSizeText(
                          "Shabdamitra",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: AutoSizeText(
                          "A digital learning aid for teaching and learning Hindi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Center(
                  child: Image.asset("assets/images/teaching.png"),
                ),
              ),
              const Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 20.0,
                  ),
                  // child: ElevatedButton(
                  //   onPressed: _onNext,
                  //   child: const AutoSizeText(
                  //     'Let\'s Go!',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //     maxLines: 1,
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _onNext,
          label: const Text("NEXT->")
      ),
    );
  }
}
