// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_application_teamproject/model/information.dart';
// import 'package:http/http.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // CollectionReference _appointmentCollection = FirebaseFirestore.instance.collection("appointment");

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("appointment")
        .where("ownerID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    return qn.docs;
  }

  navigateTodetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  RoundedRectangleBorder myRoundedborder() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 5));
  }

  RoundedRectangleBorder myRoundedborderpending() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 5));
  }

  RoundedRectangleBorder myRoundedborderaccept() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 5));
  }

  CircleAvatar myCircleAvatar() {
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 30,
        child: FittedBox(
          child: Icon(
            Icons.calendar_month,
            color: Colors.black,
          ),
        ));
  }

  CircleAvatar myCircleAvatarpending() {
    return CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 30,
        child: FittedBox(
          child: Icon(
            Icons.calendar_month,
            color: Colors.black,
          ),
        ));
  }

  CircleAvatar myCircleAvataraccept() {
    return CircleAvatar(
        backgroundColor: Colors.black,
        radius: 30,
        child: FittedBox(
          child: Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),
        ));
  }

  Widget listviewpending() {
    return FutureBuilder(
        future: getPosts(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading......"));
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                String userID = FirebaseAuth.instance.currentUser!.uid;
                Timestamp t = snapshot.data[index].data()['created'];
                DateTime d = t.toDate();
                String request = snapshot.data[index].data()['status'];
                if (snapshot.data[index].data()["ownerID"] == userID &&
                    snapshot.data[index].data()["status"] == "pending") {
                  print(request);
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Ink(
                      // height: 100,
                      color: (request == "pending")
                          ? Colors.black12
                          : Colors.black26,
                      child: ListTile(
                        // dense: true,
                        focusColor: Colors.black,
                        shape: (request == "pending")
                            ? myRoundedborderpending()
                            : myRoundedborder(),
                        leading: (request == "pending")
                            ? myCircleAvatarpending()
                            : myCircleAvatar(),
                        title: Text(snapshot.data[index].data()["doctorName"]),
                        subtitle: Text(d.toString()),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        trailing: Wrap(
                          spacing: 12,
                          // children: <Widget>[
                          //         if(request=="pending")
                          //           Icon(Icons.alarm_add,size: 40,color: Colors.yellow.shade700,),
                          //           // Text("Pending...",style: TextStyle(fontSize: 20),),
                          //         if(request=="Accept")
                          //           Icon(Icons.people_alt,size: 40,color: Colors.green.shade700),
                          //         if(request=="")
                          //           Icon(Icons.unsubscribe,size: 40,color: Colors.black87)
                          //       ],
                        ),
                        onTap: () => navigateTodetail(snapshot.data[index]),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(""),
                  );
                }
              });
        });
  }

  Widget listviewappointment() {
    return FutureBuilder(
        future: getPosts(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading......"));
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  String userID = FirebaseAuth.instance.currentUser!.uid;
                  Timestamp t = snapshot.data[index].data()['created'];
                  DateTime d = t.toDate();
                  String request = snapshot.data[index].data()['status'];

                  if(snapshot.data[index].data()["ownerID"]==userID && snapshot.data[index].data()["status"]!="pending" && snapshot.data[index].data()["status"]!="reject"){ 
                    print(request);    
                      return 
                     Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Ink(
                          color:
                         (request=="Accept")?
                          Colors.black12
                          :Colors.black26,
                            child: ListTile(
                            focusColor: Colors.black,
                             shape:
                              (request=="Accept")?
                              myRoundedborderaccept()
                              :myRoundedborder()
                             ,
                              leading:
                              (request=="Accept")?
                              myCircleAvataraccept()
                              :myCircleAvatar(),
                            title:Text(snapshot.data[index].data()["doctorName"]),      
                            subtitle: Text(d.toString()),
                            contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                            trailing:  Wrap(spacing: 12,
                            ),
                            onTap: ()=> navigateTodetail(snapshot.data[index]),
                          ),
                        ),
                      
                    );
                  } else {
                    return Center(
                      child: Text(""),
                    );
                  }
                });
          }
        });
  }

  Widget textpending() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 4),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(15.0),
      child: Text(
        'Pending Appointment',
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  Widget textshowappointment() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 4),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(15.0),
      child: Text(
        'Accept Appointment',
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          // physics: ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(height: 20,),
                textpending(),
                // listviewappointment(),
                listviewpending(),
                textshowappointment(),
                listviewappointment(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  @override
  final DocumentSnapshot post;

  DetailPage({required this.post});

  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  void initState() {
    super.initState();
    // loadinfo();
  }

  Widget listappointmentdateinformation() {
    Timestamp t = widget.post["created"];
    DateTime d = t.toDate();
    String formatDate(DateTime dates) => new DateFormat.yMMMMd().format(dates);
    String formatTimes(DateTime dates) => new DateFormat.jm().format(dates);
    return Card(
        child: Container(
      width: 360,
      height: 500,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.black87),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 120,
              width: 120,
              child: const ColoredBox(color: Colors.grey),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(children: [
              Icon(
                Icons.person,
                color: Colors.white,
              ),
              Text(
                " Doctor Name: ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                widget.post["doctorName"],
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            // Wrap(children: [
            //   Icon(
            //     Icons.store,
            //     color: Colors.white,
            //   ),
            //   Text(
            //     " Clinic Name: ",
            //     style: TextStyle(color: Colors.white, fontSize: 20),
            //   ),
            //   Text(
            //     widget.post["doctorName"],
            //     style: TextStyle(color: Colors.white, fontSize: 20),
            //   ),
            // ]),
            // SizedBox(
            //   height: 20,
            // ),
            Wrap(children: [
              Icon(
                Icons.phone,
                color: Colors.white,
              ),
              Text(
                " Phone: ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                widget.post["phone"],
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Wrap(children: [
              Icon(
                Icons.calendar_month,
                color: Colors.white,
              ),
              Text(
                "  Date:  ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                formatDate(d),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Wrap(children: [
              Icon(
                Icons.timelapse,
                color: Colors.white,
              ),
              Text(
                "  Time: ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                formatTimes(d),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Wrap(children: [
              Icon(
                Icons.health_and_safety,
                color: Colors.white,
              ),
              Text(" Symtom:                      ",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              // Text(widget.post["symtom"],style: TextStyle(color:Colors.white,fontSize: 20),),
            ]),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Text(
                  widget.post["symtom"],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      )),
    ));
  }

  Widget displaytest() {
    return Text(
      "show pending Appointment",
      style: TextStyle(fontSize: 100),
    );
  }

//   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Description"), backgroundColor: Colors.black),
      body: Center(
          child: SingleChildScrollView(
        child: Column(children: [
          listappointmentdateinformation(),
          SizedBox(
            height: 20,
          ),
          displaytest()
        ]),
      )),
    );
  }
}
