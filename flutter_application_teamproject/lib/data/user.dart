import 'package:flutter/src/widgets/framework.dart';

class Users {
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final bool isDarkMode;
  final String weight;
  final String height;
  final String blood;
  final String allergy;
  final String medicalcondition;
  final String age;

  const Users({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
    required this.weight,
    required this.height,
    required this.blood,
    required this.allergy,
    required this.medicalcondition,
    required this.age,
  });

  Users copy({
    String? imagePath,
    String? name,
    String? email,
    String? about,
    bool? isDarkMode,
    String? weight,
    String? height,
    String? blood,
    String? allergy,
    String? medicalcondition,
    String? age,
  }) =>
      Users(
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        isDarkMode: isDarkMode ?? this.isDarkMode,
        weight: weight ?? this.weight,
        height: height ?? this.height,
        blood: blood ?? this.blood,
        allergy: allergy ?? this.allergy,
        medicalcondition: medicalcondition ?? this.medicalcondition,
        age: age ?? this.age,
      );

  static Users fromJson(Map<String, dynamic> json) => Users(
        imagePath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        about: json['about'],
        isDarkMode: json['isDarkMode'],
        weight: json['weight'],
        height: json['height'],
        blood: json['blood'],
        allergy: json['allergy'],
        medicalcondition: json['medicalcondition'],
        age: json['age'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'about': about,
        'isDarkMode': isDarkMode,
        'weight': weight,
        'height': height,
        'blood': blood,
        'allergy': allergy,
        'medicalcondition': medicalcondition,
        'age': age,
      };

  map(Widget Function(Users user) buildUser) {}
}
