import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  // final uid = FirebaseAuth.instance.currentUser?.uid;

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    print(uid);
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Container(
              height: 1000,
              width: 500,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg2login.png"),
                      fit: BoxFit.cover)),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("destination")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: snapshot.data!.docs.map((document) {
                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black, spreadRadius: 1),
                                ],
                              ),
                              margin: EdgeInsets.all(20),
                              child: Material(
                                  child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        List<String> _locations = [
                                          '9:00 - 10:00',
                                          '11:00 - 12:00',
                                          '13:00 - 14:00',
                                          '15:00 - 16:00',
                                          '17:00 - 18:00'
                                        ];
                                        var available =
                                            document["availability"];
                                        var index = 0;
                                        for (bool i in available) {
                                          if (i == false) {
                                            _locations[index] = "none";
                                          }
                                          index += 1;
                                        }
                                        List<String> filtered = _locations
                                            .where((item) => item != "none")
                                            .toList();
                                        String? _dropDownValue = filtered[0];
                                        return AlertDialog(
                                          insetPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 200,
                                                  horizontal: 50),
                                          content: Stack(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: ListTile(
                                                  title: Text(document["name"],
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle:
                                                      Text(document["type"]),
                                                ),
                                              ),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(document["des"])),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                      width: 100,
                                                      child:
                                                          DropdownButtonFormField(
                                                        value: _dropDownValue,
                                                        isExpanded: true,
                                                        iconSize: 30.0,
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                        items: filtered.map(
                                                          (val) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: val,
                                                              child: Text(val),
                                                            );
                                                          },
                                                        ).toList(),
                                                        onChanged:
                                                            (String? val) {
                                                          setState(
                                                            () {
                                                              _dropDownValue =
                                                                  val;
                                                            },
                                                          );
                                                        },
                                                      ))),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: SizedBox(
                                                    width: 120,
                                                    height: 50,
                                                    child: ElevatedButton(
                                                        child: Text("Appoint"),
                                                        style: ElevatedButton.styleFrom(
                                                            primary:
                                                                Colors.black,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black87))),
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'appointment')
                                                              .add({
                                                            'created':
                                                                _dropDownValue,
                                                            'owner': uid
                                                          });
                                                          Navigator.pop(
                                                              context, true);
                                                        })),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(document["name"]),
                                      subtitle: Text(document["type"]),
                                      // onTap: (){Navigator.push(cntext,MaterialPageRoute(builder: (context)=>HomePage()));},
                                    ),
                                    RatingBarIndicator(
                                      rating: document["rating"].toDouble(),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                              )));
                        }).toList(),
                      ),
                    );
                  }
                },
              )),
        ));
  }
}
