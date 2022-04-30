import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_teamproject/data/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_teamproject/utils/user_preferences.dart';
import 'package:flutter_application_teamproject/widget/appbar_widget.dart';
import 'package:flutter_application_teamproject/widget/button_widget.dart';
import 'package:flutter_application_teamproject/widget/profile_widget.dart';
import 'package:flutter_application_teamproject/widget/textfield_widget.dart';
import 'package:path/path.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Users? user;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    user = UserPreferences.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user!.imagePath,
            isEdit: true,
            onClicked: () async {
              final image =
                  await ImagePicker().getImage(source: ImageSource.gallery);

              if (image == null) return;

              final directory = await getApplicationDocumentsDirectory();
              final name = basename(image.path);
              final imageFile = File('${directory.path}/$name');
              final newImage = await File(image.path).copy(imageFile.path);

              setState(() => user = user?.copy(imagePath: newImage.path));
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: "",
            onChanged: (name) => user = user?.copy(name: name),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Weight',
            text: "",
            onChanged: (weight) => user = user?.copy(weight: weight),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Height',
            text: "",
            onChanged: (height) => user = user?.copy(height: height),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Age',
            text: "",
            onChanged: (age) => user = user?.copy(age: age),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Allergies',
            text: "",
            onChanged: (allergy) => user = user?.copy(allergy: allergy),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Medical Condition',
            text: "",
            onChanged: (medicalcondition) =>
                user = user?.copy(medicalcondition: medicalcondition),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Blood Type',
            text: "",
            onChanged: (blood) => user = user?.copy(blood: blood),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Description',
            text: "",
            maxLines: 5,
            onChanged: (about) => user = user?.copy(about: about),
          ),
          const SizedBox(height: 24),
          ButtonWidget(
            text: 'Save',
            onClicked: () {
              UserPreferences.setUser(user!);
              Navigator.of(context).pop();
              final docUser = FirebaseFirestore.instance
                  .collection("Profile")
                  .doc(auth.currentUser!.uid);
              docUser.update({
                'name': user!.name,
                'description': user!.about,
                'weight': user!.weight,
                'height': user!.height,
                'blood': user!.blood,
                'medicalcondition': user!.medicalcondition,
                'allergy': user!.allergy,
                'age': user!.age,
              });
            },
          ),
        ],
      ),
    );
  }
}
