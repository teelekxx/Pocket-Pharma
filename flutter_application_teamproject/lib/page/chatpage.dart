// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_teamproject/model/information.dart';
// import 'package:http/http.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}



class _AppointmentPageState extends State<AppointmentPage> {
  // CollectionReference _appointmentCollection = FirebaseFirestore.instance.collection("appointment");
 
  Future getPosts() async{
    var firestore =FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("appointment").where("owner",isEqualTo:FirebaseAuth.instance.currentUser!.uid).get();
    return qn.docs;
  }

navigateTodetail(DocumentSnapshot post){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(post:post,)));
}

// void initState(){
//   super.initState();  
//   // var _data =getPosts();
// }

  @override
  Widget build(BuildContext context) {
    // QuerySnapshot snapid = FirebaseFirestore.instance.collection("appointment").where("owner",isEqualTo:currentuser!.uid).get();
    
    //  return Container(
    //   // height: 250,
    //   width: 500,
    //   child: StreamBuilder(
    //       stream:_appointmentCollection.snapshots(),
    //       builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
    //         if(!snapshot.hasData){
    //           return Center(child:CircularProgressIndicator(),);
    //         }
    //         final data = snapshot.requireData;
    //         return Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: Card(
    //                           child: ListView(
    //               children:snapshot.data!.docs.map((document){
                  
    //                 Timestamp t = document['created'];
    //                 DateTime d =t.toDate();
    //                 return Container(
    //                   margin:EdgeInsets.all(20),
    //                   child: ListTile(
    //                     shape: RoundedRectangleBorder(borderRadius: 
    //                     BorderRadius.circular(10),
    //                     side: BorderSide(color: Colors.black)),
    //                     leading:CircleAvatar(
    //                       radius:30,
    //                       child:FittedBox(child: Icon(Icons.calendar_month)
    //                       ,)
    //                     ),
    //                     title:Text(d.toString()),
    //                     subtitle:  Text(document["ownerName"]+" "+document["text"]),    
    //                     contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
    //                     trailing:  Wrap(spacing: 12,
    //                     children: <Widget>[              
    //                       Icon(Icons.arrow_circle_right)
    //                     ],),
    //                     onTap:() => 
    //                     navigateTodetail(snapshot.data),
    //                   ),
    //                 );
    //               }).toList(),         
    //             ),
    //           ),
    //         );
    //       },
    //    ),
    // );
    return Center(
      child: Container(
        //  height: 250,
        //  width: 500,
        child: FutureBuilder(
          future: getPosts(),
          builder:(_, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child:Text("Loading......")
            );
          }
          // if(snapshot.hasData){        
          //   return Center(child: Text("Don't have  data"));
          // }
          // Map<String,dynamic> docu =snapshot.data();  
          // try{       
              return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder:(_,index){
              String userID =FirebaseAuth.instance.currentUser!.uid;
              Timestamp t = snapshot.data[index].data()['created'];
              DateTime d =t.toDate();
              if(snapshot.data[index].data()["owner"]==userID){ 
                    return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                     shape: RoundedRectangleBorder(borderRadius: 
                          BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black)),
                          leading:CircleAvatar(
                            radius:30,
                            child:FittedBox(child: Icon(Icons.calendar_month)
                            ,)
                          ),
                    title: Text(snapshot.data[index].data()["ownerName"]),
                    subtitle: Text(d.toString()),
                    contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                    trailing:  Wrap(spacing: 12,
                    children: <Widget>[              
                            Icon(Icons.arrow_circle_right)
                          ],),
                    onTap: ()=> navigateTodetail(snapshot.data[index]),
                  ),
                );     
                // return Center(child: Text("Don't have any information"),);
              }
              else{
                return Center(child: Text(""),);
              }
            }
            ); 
          // }catch(e){
          //   print(e);
          // }  
            return Text("loading...");      
        }),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  @override
  final DocumentSnapshot post;

  DetailPage( {required this.post});

  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  
//   var titles ="eiei";
  // List<Information> information =[];
  

void initState(){
  super.initState();  
  // loadinfo();
}

// void loadinfo() {
//   FirebaseFirestore.instance.collection("appointment").doc(FirebaseAuth.instance.currentUser!.uid).get().then((snapshot){ 
//     for(var info in snapshot.data()!["owner"]){ 
//         FirebaseFirestore.instance.collection("Medical").doc(info).get().then((infosnapshot){
//           setState(() {
//             information.add(
//               Information(
//                 name:infosnapshot["Name"],
//                 rate: infosnapshot["Rating"],
//                 type: infosnapshot["Type"])
//             );
//             // titles = infosnapshot["Type"];
//             // print(titles+"testttttttttt");
//           });
//         });
//     }
//   });
//   print(FirebaseAuth.instance.currentUser!.uid);
//   print(information);
// }
//   @override
  Widget build(BuildContext context) {
    
//     final Stream<QuerySnapshot> _bmStreams = FirebaseFirestore.instance.collection('appointment').snapshots(includeMetadataChanges: true);  
//     return StreamBuilder<QuerySnapshot>(
//       stream: _bmStreams,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
//          if (!snapshot.hasData) {
//           return Text('Something went wrong');
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text("Loadingsss");
//         }
//         // print(snapshot.data.data());
//         return Scaffold(
//           appBar: AppBar(
//               title: Text('My Questions'),
        
//           ),
//               body: Container(
//               child:ListView.builder(
//                     // shrinkWrap: true,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, int index) {
//                     final DocumentSnapshot ds = snapshot.data!.docs[index];
//                     if (!ds.exists) print('not exists');
//   // here we return the second StreamBuilder
//                     print(ds);
//                     return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                           stream: FirebaseFirestore.instance.collection('Medical').doc(ds.id).snapshots(),
//                           builder: (BuildContext context,
//                           AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//                           qSnapshot) {  
//                            Map<String, dynamic>? datas = ds.data() as Map<String, dynamic>?;       
//                           print(ds.id);
//                           if (qSnapshot.hasData) return Text(datas!["ownerName"]);
//                           if (qSnapshot.connectionState == ConnectionState.waiting)  return Text("Loading Content");                        
//                           print(datas!["text"] ); // should print the question
//                           return Text(datas["text"]);
//     },
//   );
// },
//                   )
//           ),
//         );
//       }
//       );   
  
    return Scaffold(
      appBar: AppBar(title:Text("test")),
         body:Card(
              child:ListTile(
                title: Text(widget.post["text"]),
                  subtitle: Text(widget.post["ownerName"]),
              ) 
              
                 ),
        
    );
  }
}