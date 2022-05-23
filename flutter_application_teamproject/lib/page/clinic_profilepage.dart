// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_teamproject/data/user.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_teamproject/page/clinic_edit_profile_page.dart';
import 'package:flutter_application_teamproject/utils/user_preferences.dart';
import 'package:flutter_application_teamproject/widget/appbar_widget.dart';
// import 'package:flutter_application_teamproject/widget/button_widget.dart';
import 'package:flutter_application_teamproject/widget/profile_widget.dart';
import 'package:flutter_application_teamproject/widget/doctor_user_widget.dart';
import 'package:flutter_application_teamproject/widget/doctor_stat_widget.dart';
import 'package:flutter_application_teamproject/widget/doctor_description_widget.dart';
import 'package:flutter_application_teamproject/widget/button_widget.dart';

class ClinicProfilePage extends StatefulWidget {
  @override
  _ClinicProfilePageState createState() => _ClinicProfilePageState();
}

class _ClinicProfilePageState extends State<ClinicProfilePage> {
  final auth = FirebaseAuth.instance;
  bool _flag = true;

  Future<void> changeStatus() async {
    final snapShot = await FirebaseFirestore.instance
        .collection('Doctor')
        .doc(auth.currentUser!.uid);

    if (_flag) {
      snapShot.update({"status": "avaliable"});
    } else {
      snapShot.update({"status": "unavaliable"});
    }

    _flag = !_flag;
  }

  @override
  Widget build(BuildContext context) {
    final users = UserPreferences.getUser();

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: users.imagePath,
            onClicked: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ClinicEditProfilePage()),
              );
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          DoctorUserWidget(),
          const SizedBox(height: 24),
          DoctorStatWidget(),
          const SizedBox(height: 48),
          DoctorDescriptionWidget(),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Doctor")
                  .where('doctorID', isEqualTo: auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: snapshot.data!.docs.map((document) {
                    if (document["status"] == "avaliable") {
                      _flag = false;
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            child: Text(_flag ? 'Unavaliable' : 'Avaliable'),
                            onPressed: () async {
                              await changeStatus();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: _flag
                                  ? Colors.red
                                  : Colors.teal, // This is what you need!
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );

                // return ElevatedButton(
                //   child: Text(_flag ? 'Red' : 'Green'),
                //   onPressed: () {
                //     setState(() => _flag = !_flag);
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: _flag
                //         ? Colors.red
                //         : Colors.teal, // This is what you need!
                //   ),
                // );
              }),
        ],
      ),
    );
  }
}
