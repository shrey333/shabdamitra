import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/ErrorHandlers/not_found.dart';
import 'package:shabdamitra/ErrorHandlers/error.dart';
import 'package:shabdamitra/application_context.dart';
import 'package:shabdamitra/homepage.dart';
import 'package:shabdamitra/onboarding/introduction.dart';

void main() async {
  await GetStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'मराठी शब्दमित्र',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: const Color.fromRGBO(254, 254, 255, 255),
        fontFamily: 'Inter',
      ),
      builder: (context, widget) {
        ErrorWidget.builder =
            (FlutterErrorDetails details) => const ErrorRoute();
        return widget as Widget;
      },
      home: ApplicationContext().isOnboardingDone()
          ? const HomePage()
          : const Introduction(),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const PageNotFoundRoute());
      },
    );
  }
}
