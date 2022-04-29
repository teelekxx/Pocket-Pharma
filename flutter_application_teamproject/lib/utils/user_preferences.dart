import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_teamproject/data/user.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static const _keyUser = 'user';
  static const myUser = Users(
    imagePath:
        'https://www.pngitem.com/pimgs/m/524-5246388_anonymous-user-hd-png-download.png',
    name: 'User',
    email: 'sarah.abs@gmail.com',
    about: 'No Description',
    isDarkMode: false,
    weight: "69",
    height: "174",
    blood: 'O',
    allergy: 'None',
    medicalcondition: 'None',
    age: "21",
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(Users user) async {
    final json = jsonEncode(user.toJson());

    await _preferences?.setString(_keyUser, json);
  }

  static Users getUser() {
    final json = _preferences?.getString(_keyUser);

    return json == null ? myUser : Users.fromJson(jsonDecode(json));
  }
}
