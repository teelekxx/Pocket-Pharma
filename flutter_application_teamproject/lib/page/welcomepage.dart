import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/data/menu_items.dart';
import 'package:flutter_application_teamproject/model/meun_item.dart';
import 'package:flutter_application_teamproject/page/chatpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_teamproject/page/clinic_appoinmentpage.dart';
// import 'package:flutter_application_teamproject/page/home.dart';
import 'package:flutter_application_teamproject/page/homepage.dart';
import 'package:flutter_application_teamproject/page/mappage.dart';
import 'package:flutter_application_teamproject/page/profilepage.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';
import 'package:flutter_application_teamproject/page/clinic_homepage.dart';
import 'package:flutter_application_teamproject/page/clinic_profilepage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  var firestore = FirebaseFirestore.instance;
  int index = 0;

  var destination = [
    NavigationDestination(
      icon: Icon(
        Icons.home_outlined,
        color: Colors.white,
      ),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.map_outlined, color: Colors.white),
      selectedIcon: Icon(Icons.map),
      label: 'Map',
    ),
    NavigationDestination(
      icon: Icon(Icons.chat_outlined, color: Colors.white),
      selectedIcon: Icon(Icons.chat),
      label: 'Appointment',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline, color: Colors.white),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  var screen = [
    MainPage(),
    MapPage(),
    AppointmentPage(),
    ProfilePage(),
  ];

  Future<bool> checkClinic() async {
    final snapShot =
        await FirebaseFirestore.instance.collection('clinic').doc(uid).get();

    return snapShot.exists;
    // screen = [
    //   MainPage(),
    //   ProfilePage(),
    // ];
    // destination = [
    //   NavigationDestination(
    //     icon: Icon(
    //       Icons.home_outlined,
    //       color: Colors.white,
    //     ),
    //     selectedIcon: Icon(Icons.home),
    //     label: 'Home',
    //   ),
    //   NavigationDestination(
    //     icon: Icon(Icons.map_outlined, color: Colors.white),
    //     selectedIcon: Icon(Icons.map),
    //     label: 'Map',
    //   ),
    // ];
  }

  @override
  Widget build(BuildContext context) {
    checkClinic().then((isClinic) {});

    return Scaffold(
        appBar: AppBar(
          title: Text("Welcompage"),
          actions: [
            // IconButton(icon: Icon(Icons.search),onPressed: (){
            //   showSearch(context: context, delegate: MySearchDelegate());
            // }) ,
            PopupMenuButton<MenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemFirst.map(buildItem).toList(),
                PopupMenuDivider(),
                ...MenuItems.itemSecond.map(buildItem).toList(),
              ],
            )
          ],
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder<bool>(
          future: checkClinic(),
          builder: (context, data) {
            if (data.hasData && data.data == false) {
              return Scaffold(
                  body: screen[index],
                  bottomNavigationBar: NavigationBarTheme(
                    data: NavigationBarThemeData(
                      indicatorColor: Colors.white,
                      labelTextStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                    ),
                    child: navigatorbar(),
                  ));
            } else if (data.hasData && data.data == true) {
              screen = [
                ClinicAppointmnetPage(),
                ClinicProfilePage(),
              ];
              destination = [
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, color: Colors.white),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ];
              return Scaffold(
                  body: screen[index],
                  bottomNavigationBar: NavigationBarTheme(
                    data: NavigationBarThemeData(
                      indicatorColor: Colors.white,
                      labelTextStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                    ),
                    child: navigatorbar(),
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
        // body: screen[index],
        // bottomNavigationBar: NavigationBarTheme(
        //   data: NavigationBarThemeData(
        //     indicatorColor: Colors.white,
        //     labelTextStyle: MaterialStateProperty.all(TextStyle(
        //         fontSize: 14,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.white)),
        //   ),
        //   child: navigatorbar(),
        // )
        );
  }

  NavigationBar navigatorbar() {
    return NavigationBar(
        backgroundColor: Colors.black,
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        animationDuration: Duration(seconds: 1),
        onDestinationSelected: (index) => setState(() => this.index = index),
        destinations: destination);
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
      value: item,
      child: Row(
        children: [
          Icon(item.icon, color: Colors.yellow, size: 20),
          const SizedBox(width: 12),
          Text(item.text)
        ],
      ));

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemSetting:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
      case MenuItems.itemSignout:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
        break;
    }
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            })
      ];
  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      });
  @override
  Widget buildSuggestions(BuildContext context) => Text("Suggestions go here");
  @override
  Widget buildResults(BuildContext context) => Text("Results go here");
}
