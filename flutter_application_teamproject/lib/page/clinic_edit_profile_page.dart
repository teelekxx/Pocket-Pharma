import 'dart:io';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_teamproject/data/user.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_teamproject/utils/user_preferences.dart';
import 'package:flutter_application_teamproject/widget/appbar_widget.dart';
import 'package:flutter_application_teamproject/widget/button_widget.dart';
import 'package:flutter_application_teamproject/widget/profile_widget.dart';
import 'package:flutter_application_teamproject/widget/textfield_widget.dart';
import 'package:path/path.dart';

class ClinicEditProfilePage extends StatefulWidget {
  @override
  _ClinicEditProfilePageState createState() => _ClinicEditProfilePageState();
}

class _ClinicEditProfilePageState extends State<ClinicEditProfilePage> {
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
            label: 'Phone',
            text: "",
            onChanged: (phone) => user = user?.copy(phone: phone),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Type',
            text: "",
            onChanged: (type) => user = user?.copy(type: type),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Status',
            text: "",
            onChanged: (status) => user = user?.copy(status: status),
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
                  .collection("Doctor")
                  .doc(auth.currentUser!.uid);
              docUser.update({
                'doctorName': user!.name,
                'des': user!.about,
                'phone': user!.phone,
                'type': user!.type,
                'status': user!.status,
              });
            },
          ),
        ],
      ),
    );
  }
}
