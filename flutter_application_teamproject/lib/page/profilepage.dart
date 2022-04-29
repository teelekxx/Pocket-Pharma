import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_teamproject/data/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_teamproject/page/edit_profile_page.dart';
import 'package:flutter_application_teamproject/utils/user_preferences.dart';
import 'package:flutter_application_teamproject/widget/appbar_widget.dart';
import 'package:flutter_application_teamproject/widget/button_widget.dart';
import 'package:flutter_application_teamproject/widget/description_widget.dart';
import 'package:flutter_application_teamproject/widget/user_widget.dart';
import 'package:flutter_application_teamproject/widget/stat_widget.dart';
import 'package:flutter_application_teamproject/widget/profile_widget.dart';

import '../widget/secondstat_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final users = UserPreferences.getUser();

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: users.imagePath,
            onClicked: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          UserWidget(),
          const SizedBox(height: 24),
          StatWidget(),
          const SizedBox(height: 24),
          SecondStatWidget(),
          const SizedBox(height: 48),
          DescriptionWidget(),
        ],
      ),
    );
  }
}
