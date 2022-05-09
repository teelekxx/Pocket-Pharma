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
 
  Future getPosts() async{
    var firestore =FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("appointment").where("owner",isEqualTo:FirebaseAuth.instance.currentUser!.uid).get();
    return qn.docs;
  }

navigateTodetail(DocumentSnapshot post){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(post:post,)));
}

RoundedRectangleBorder myRoundedborder() {
    return RoundedRectangleBorder(
         borderRadius:BorderRadius.circular(10),
        side: BorderSide(color: Colors.black,width: 5));
  }

RoundedRectangleBorder myRoundedborderpending() {
    return RoundedRectangleBorder(
         borderRadius:BorderRadius.circular(10),
        side: BorderSide(color: Colors.yellow.shade600,width: 5));
  }

RoundedRectangleBorder myRoundedborderaccept() {
    return RoundedRectangleBorder(
         borderRadius:BorderRadius.circular(10),
        side: BorderSide(color: Colors.green,width: 5));
  }

CircleAvatar myCircleAvatar(){
  return CircleAvatar(
          backgroundColor:Colors.black,
          radius:30,
          child:FittedBox(child: Icon(Icons.calendar_month,color: Colors.white,)
            ,)
    );
}

CircleAvatar myCircleAvatarpending(){
  return CircleAvatar(
          backgroundColor:Colors.yellow,
          radius:30,
          child:FittedBox(child: Icon(Icons.calendar_month,color: Colors.black,)
            ,)
    );
}

CircleAvatar myCircleAvataraccept(){
  return CircleAvatar(
          backgroundColor:Colors.green,
          radius:30,
          child:FittedBox(child: Icon(Icons.calendar_month,color: Colors.black,)
            ,)
    );
}


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
              String request = snapshot.data[index].data()['status'];
              if(snapshot.data[index].data()["owner"]==userID){ 
                print(request);    
                  return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Ink(
                    color:(request=="pending")?
                    Colors.yellow[100]:
                    (request=="Accept")?
                    Colors.green[100]
                    :Colors.black26,
                      child: ListTile(
                      focusColor: Colors.black,
                       shape:(request=="pending")?
                        myRoundedborderpending():
                        (request=="Accept")?
                        myRoundedborderaccept()
                        :myRoundedborder()
                       ,
                        leading:(request=="pending")?
                         myCircleAvatarpending():
                        (request=="Accept")?
                        myCircleAvataraccept()
                        :myCircleAvatar(),
                      title:Text(snapshot.data[index].data()["doctorName"]+" wow"),      
                      // title: RichText(text: TextSpan(children:[
                      
                      //   // WidgetSpan(child: Icon(Icons.people)),
                      //   // TextSpan(text:"hi"+snapshot.data[index].data()["ownerName"])
                      // ]),
                      // ),
                      subtitle: Text(d.toString()),
                      contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                      trailing:  Wrap(spacing: 12,
                      children: <Widget>[ 
                              if(request=="pending")      
                                Icon(Icons.alarm_add,size: 40,color: Colors.yellow.shade700,), 
                                // Text("Pending...",style: TextStyle(fontSize: 20),),         
                              if(request=="Accept")
                                Icon(Icons.people_alt,size: 40,color: Colors.green.shade700),
                              if(request=="")
                                Icon(Icons.unsubscribe,size: 40,color: Colors.black87)
                            ],),
                      onTap: ()=> navigateTodetail(snapshot.data[index]),
                    ),
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
  
void initState(){
  super.initState();  
  // loadinfo();
}

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
    Timestamp t = widget.post["created"];
    DateTime d =t.toDate();
    String formatDate(DateTime dates) => new DateFormat.yMMMMd().format(dates);
    String formatTimes(DateTime dates) => new DateFormat.jm().format(dates);
  
    return Scaffold(
      appBar: AppBar(title:Text("Description"),
      backgroundColor: Colors.black),
         body:Center(
           child: Card(
                child:Container(
                  width: 360,
                  height: 500,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black87),
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
                                Icon(Icons.person,color: Colors.white,),
                                Text(" Doctor Name: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                 Text(widget.post["doctorName"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),
                           SizedBox(
                            height: 20,
                          ),
                           Wrap(children: [
                                Icon(Icons.store,color: Colors.white,),
                                Text(" Clinic Name: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                Text(widget.post["clinicName"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),        
                           SizedBox(
                            height: 20,
                          ),
                            Wrap(children: [
                                Icon(Icons.phone,color: Colors.white,),
                                Text(" Phone: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                Text(widget.post["phone"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),        
                           SizedBox(
                            height: 20,
                          ),
                           Wrap(children: [
                                Icon(Icons.calendar_month,color: Colors.white,),
                                Text("  Date:  ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                Text(formatDate(d),style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),        
                           SizedBox(
                            height: 20,
                          ),
                          Wrap(children: [
                                Icon(Icons.timelapse,color: Colors.white,),
                                Text("  Time: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                Text(formatTimes(d),style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),        
                           SizedBox(
                            height: 20,
                          ),
                          
                           Wrap(children: [
                                    Icon(Icons.health_and_safety,color: Colors.white,),
                                    Text(" Symtom:                      ",style: TextStyle(fontSize: 20,color: Colors.white)),
                                    // Text(widget.post["symtom"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]), 
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              child:Text(widget.post["symtom"],style: TextStyle(color:Colors.white,fontSize: 20),), ),
                          )      
                        ],
                      ),
                    )
                    ),

                ) 
                
                   ),
         ),
        
    );
  }
}