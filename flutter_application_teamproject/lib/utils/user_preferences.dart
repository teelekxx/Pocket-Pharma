import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_teamproject/data/user.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static const _keyUser = 'user';
  static const myUser = Users(
    imagePath:
        'https://www.baxterip.com.au/wp-content/uploads/2019/02/anonymous.jpg',
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
    phone: "08452556721",
    type: 'Dentist',
    status: 'available',
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
