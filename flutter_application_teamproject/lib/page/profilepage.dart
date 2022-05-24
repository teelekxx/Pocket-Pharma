// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_teamproject/data/user.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_teamproject/page/edit_profile_page.dart';
import 'package:flutter_application_teamproject/utils/user_preferences.dart';
import 'package:flutter_application_teamproject/widget/appbar_widget.dart';
// import 'package:flutter_application_teamproject/widget/button_widget.dart';
import 'package:flutter_application_teamproject/widget/description_widget.dart';
import 'package:flutter_application_teamproject/widget/user_widget.dart';
import 'package:flutter_application_teamproject/widget/stat_widget.dart';
import 'package:flutter_application_teamproject/widget/profile_widget.dart';
import 'package:flutter_application_teamproject/widget/prescription_widget.dart';
import 'package:flutter_application_teamproject/page/video_call_screen.dart';
import '../data/user.dart';
import '../widget/secondstat_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = FirebaseAuth.instance;
  bool isPic = true;

  @override
  Widget build(BuildContext context) {
    Users? users = UserPreferences.getUser();

    return Scaffold(
      appBar: AppBar(title: const Text('ProfileEIEI'), actions: [
        IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VideoCallScreen()),
          ),
          icon: const Icon(Icons.video_camera_front),
        ),
      ]),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 22),
        physics: BouncingScrollPhysics(),
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Profile")
                  .where('user_id', isEqualTo: auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: snapshot.data!.docs.map((document) {
                    users = UserPreferences.getUser();
                    users = users?.copy(name: document["name"]);
                    users = users?.copy(weight: document["weight"]);
                    users = users?.copy(height: document["height"]);
                    users = users?.copy(age: document["age"]);
                    users = users?.copy(allergy: document["allergy"]);
                    users = users?.copy(
                        medicalcondition: document["medicalcondition"]);
                    users = users?.copy(blood: document["blood"]);
                    users = users?.copy(about: document["description"]);
                    users = users?.copy(imagePath: document["picture"]);
                    UserPreferences.setUser(users!);
                    return ProfileWidget(
                      imagePath: document["picture"],
                      onClicked: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        );
                        setState(() {});
                      },
                    );
                  }).toList(),
                );
              }),
          const SizedBox(height: 24),
          UserWidget(),
          const SizedBox(height: 24),
          StatWidget(),
          const SizedBox(height: 24),
          SecondStatWidget(),
          const SizedBox(height: 48),
          DescriptionWidget(),
          const SizedBox(height: 24),
          Text(
            'Prescription History',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          PrescriptionWidget(),
        ],
      ),
    );
  }
}

// ProfileWidget(
//                     imagePath: isPic ? users.imagePath : ,
//                     onClicked: () async {
//                       await Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => EditProfilePage()),
//                       );
//                       setState(() {});
//                     },
//                   ),