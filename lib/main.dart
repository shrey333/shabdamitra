import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shabdamitra/ErrorHandlers/not_found.dart';
import 'package:shabdamitra/homepage.dart';
import 'package:shabdamitra/onboarding/select_user_type.dart';

void main() async {
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GetStorage _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shabdamitra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: _storage.read('userType') == null ? const SelectUserType() : const HomePage(),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const PageNotFoundRoute());
      },
    );
  }
}
