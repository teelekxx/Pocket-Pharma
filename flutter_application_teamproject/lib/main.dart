// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';
// import 'package:flutter_application_teamproject/page/profilepage.dart';
// import 'package:flutter_application_teamproject/themes.dart';
import 'package:flutter_application_teamproject/utils/user_preferences.dart';
import 'package:dcdg/dcdg.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'User Profile';
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        primaryColorLight: Colors.white,
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline3: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
          headline4: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
          headline5: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          ),
          headline6: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
