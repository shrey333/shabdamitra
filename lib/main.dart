import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/ErrorHandlers/not_found.dart';
import 'package:shabdamitra/ErrorHandlers/error.dart';
import 'package:shabdamitra/homepage.dart';
import 'package:shabdamitra/onboarding/introduction.dart';

void main() async {
  await GetStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GetStorage _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    // Following line of code is for dev only.
    // Makes sure that onboarding is show on every run.
    //  _storage.remove('onboardingDone');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shabdamitra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: const Color.fromRGBO(254, 254, 255, 255),
        fontFamily: 'Inter',
      ),
      builder: (context, widget) {
        ErrorWidget.builder =
            (FlutterErrorDetails details) => const ErrorRoute();
        Widget a = widget as Widget;
        return a;
      },
      home: _storage.read('onboardingDone') == null
          ? const Introduction()
          : const HomePage(),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const PageNotFoundRoute());
      },
    );
  }
}
