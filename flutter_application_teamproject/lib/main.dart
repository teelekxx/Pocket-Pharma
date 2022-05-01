import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';
// import 'package:flutter_application_teamproject/page/profilepage.dart';
// import 'package:flutter_application_teamproject/themes.dart';
import 'package:flutter_application_teamproject/utils/user_preferences.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

