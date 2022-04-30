import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final name = FirebaseAuth.instance.currentUser?.displayName;
  // final uid = FirebaseAuth.instance.currentUser?.uid;

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedDoctor = "";
  String selectedClinic = "";
  String selectedPhone = "";
  var textController = TextEditingController();

  DateTime join(DateTime date, TimeOfDay time) {
    return new DateTime(
        date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        selectedDate = join(selectedDate, selectedTime);
        FirebaseFirestore.instance.collection('appointment').add({
          'created': selectedDate,
          'owner': uid,
          'symtom': textController.text,
          'doctorName': selectedDoctor,
          'clinicName': selectedClinic,
          'phone': selectedPhone,
        });
        Fluttertoast.showToast(
            msg: "Appointed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _selectTime(context);
      });
    }
  }

  Future<void> _appointment(BuildContext context) async {
    final String? des = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: const EdgeInsets.all(10.0),
              content: Container(
                  width: double.maxFinite,
                  child: ListView(children: [
                    Text("Please tell us about yourself",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Type here....',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 20,
                      minLines: 1,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                            child: Text("Next"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black87))),
                            onPressed: () {
                              _selectDate(context);
                            }))
                  ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    print(name);
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
                                  textController.text = "";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        DateTime showDate = selectedDate;
                                        return AlertDialog(
                                          insetPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 200,
                                                  horizontal: 50),
                                          content: Column(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: ListTile(
                                                  title: Text(
                                                      document["clinicName"],
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  subtitle: Text(
                                                      document["doctorName"] +
                                                          ",  " +
                                                          document["type"]),
                                                ),
                                              ),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Text(document["des"])),
                                              SizedBox(
                                                height: 120,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: SizedBox(
                                                    width: 100,
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
                                                          selectedDoctor =
                                                              document[
                                                                  "doctorName"];
                                                          selectedClinic =
                                                              document[
                                                                  "clinicName"];
                                                          selectedPhone =
                                                              document["phone"];
                                                          _appointment(context);
                                                          // _selectDate(context);
                                                        })),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.add_moderator,
                                      color: Colors.green,
                                      size: 25,
                                    ),
                                    ListTile(
                                      title: Text(document["clinicName"]),
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
