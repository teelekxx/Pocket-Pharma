// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ClinicAppointmnetPage extends StatefulWidget {
  @override
  _ClinicAppointmnetPageState createState() => _ClinicAppointmnetPageState();
}

class _ClinicAppointmnetPageState extends State<ClinicAppointmnetPage> {
  Future getPosts() async{
    var firestore =FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("appointment").where("doctorID",isEqualTo:FirebaseAuth.instance.currentUser!.uid).get();
    return qn.docs;
  }

  navigateTodetail(DocumentSnapshot post){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsPage(post:post,)));
}
RoundedRectangleBorder myRoundedborder() {
    return RoundedRectangleBorder(
         borderRadius:BorderRadius.circular(10),
        side: BorderSide(color: Colors.black,width: 5));
  }

RoundedRectangleBorder myRoundedborderpending() {
    return RoundedRectangleBorder(
         borderRadius:BorderRadius.circular(10),
        side: BorderSide(color: Colors.black,width: 5));
  }

RoundedRectangleBorder myRoundedborderaccept() {
    return RoundedRectangleBorder(
         borderRadius:BorderRadius.circular(10),
        side: BorderSide(color: Colors.black,width: 5));
  }

CircleAvatar myCircleAvatar(){
  return CircleAvatar(
          backgroundColor:Colors.white,
          radius:30,
          child:FittedBox(child: Icon(Icons.calendar_month,color: Colors.black,)
            ,)
    );
}

CircleAvatar myCircleAvatarpending(){
  return CircleAvatar(
          backgroundColor:Colors.blue,
          radius:30,
          child:FittedBox(child: Icon(Icons.calendar_month,color: Colors.black,)
            ,)
    );
}

CircleAvatar myCircleAvataraccept(){
  return CircleAvatar(
          backgroundColor:Colors.black,
          radius:30,
          child:FittedBox(child: Icon(Icons.calendar_month,color: Colors.white,)
            ,)
    );
}

Widget listviewpending(){
  return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("appointment").where("doctorID",isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder:(_, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child:Text("Loading......")
                );
              }  
                  return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder:(_,index){
                  var docs = snapshot.data.docs;
                  final appointmnet = docs[index].data()!;
                  String userID =FirebaseAuth.instance.currentUser!.uid;
                  Timestamp t = appointmnet['created'];
                  DateTime d =t.toDate();
                  String request = appointmnet['status'];
                  if(appointmnet["doctorID"]==userID && appointmnet["status"]=="pending"){ 
                    print(request);    
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Ink(
                        // height: 100,
                          color:(request=="pending")?
                          Colors.black12
                          :Colors.black26,
                            child: ListTile(
                            // dense: true,
                            focusColor: Colors.black,
                             shape:(request=="pending")?
                              myRoundedborderpending()
                              :myRoundedborder()
                             ,
                              leading:(request=="pending")?
                               myCircleAvatarpending()
                              :myCircleAvatar(),
                            title:Text(appointmnet["ownerName"]),      
                            subtitle: Text(d.toString()),
                            contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                            trailing:  Wrap(spacing: 12,
                            children: <Widget>[ 
                                     ElevatedButton.icon(      
                                        onPressed: (){                                    
                                          // String keyID = snapshot.data[index].data()["clinicID"];
                                          // String ownerID = snapshot.data[index].data()["owner"];
                                          // print(keyID);
                                          // print(ownerID);
                                          print(snapshot.data.docs[index].reference.id);
                                          FirebaseFirestore.instance.collection("appointment").doc(snapshot.data.docs[index].reference.id).update({"status":"Accept"});
                                           Fluttertoast.showToast(
                                            msg: "Accept!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            textColor: Colors.white,
                                            fontSize: 16.0);                                       
                                          // print("Acceptss");
                                          }, 
                                        icon: Icon(Icons.check,size: 20,color: Colors.yellow.shade700),
                                        label: Text(""),) ,
                                      ElevatedButton(      
                                        onPressed: (){
                                          print("Click!!!!");
                                           FirebaseFirestore.instance.collection("appointment").doc(snapshot.data.docs[index].reference.id).update({"status":"reject"});
                                            Fluttertoast.showToast(
                                            msg: "reject!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            textColor: Colors.white,
                                            fontSize: 16.0);          
                                          },
                                        child: Text("X"),) ,  
            
                                  ],),
                            onTap: ()=> navigateTodetail(docs[index]),
                          ),
                        ),
                    )
                      ;     
                    // return Center(child: Text("Don't have any information"),);
                  }
                  else{
                    return Center(child: Text(""),);
                  }
                }
                ); 
                return Text("loading...");      
            });
}

//  getage(String petId) async {
//     DocumentReference documentReference =FirebaseFirestore.instance.collection('Profile').doc(petId);
//     String specie  ="";
//     await documentReference.get().then((snapshot) {
//       specie = (snapshot.data() as Map<String, dynamic>)['age'] as String;
//     });
//     print(specie);
//     return specie;
//   }

// Future<String> getAge(String userID) async {
//   String specie  ="";
//   await Firebase.initializeApp().then((value) => 
//     FirebaseFirestore.instance.collection('Profile').doc(userID).snapshots().listen(
//       (event) { 
//        specie = event.data()!['age'];
//       //  print(specie);
//       }
//       )
//   );
//   return specie;
// }

Future<void> createprescription(BuildContext context,String doctorname,String currentid,String userid,String phonenum,String allergy,String username,String userage,String userWeight, String userHeight) async {
    var textController = TextEditingController();  
    DateTime currentphonedate = DateTime.now();
    final String? des = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: const EdgeInsets.all(10.0),
              content: Container(
                  width: double.maxFinite,
                  child: ListView(children: [
                    Text("Patient Prescription",textAlign: TextAlign.center,style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Patient information:",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    
                    Text(" Name: ${username}",style: TextStyle(fontSize: 20)),
                    Text(" Age: ${userage}",style: TextStyle(fontSize: 20)),
                    Text(" Allergy: ${allergy}",style: TextStyle(fontSize: 20)),
                    Text(" Weight nad Height: ${userWeight} , ${userHeight}",style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Rx Prescription",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
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
                            child: Text("Comfirm"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black87))),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('prescription').add({
                              'createBy':doctorname,
                              // 'owner': uid,
                              'rxPrescription': textController.text,
                              // 'doctorName': selectedDoctor,
                              'dateTime':currentphonedate,
                              'patientID':userid,
                              'phone': phonenum,
                            });
                            FirebaseFirestore.instance.collection("appointment").doc(currentid).update({"status":"Success"});  
                            Fluttertoast.showToast(
                            msg: "Make a Prescription!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0);
                            Navigator.of(context, rootNavigator: true).pop();
                            }
                            
                            
                            ),
                        )
                  ]
                  )));
        });
  }


Widget listviewappointment(){
  return StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection("appointment").where("doctorID",isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder:(_, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child:Text("Loading......")
                );
              }
              else{   
                
                  return ListView.builder(         
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder:(_,index){
                  var docs = snapshot.data.docs;
                  final appointmnet = docs[index].data()!;
                  String userID =FirebaseAuth.instance.currentUser!.uid;
                  Timestamp t = appointmnet['created'];
                  DateTime d =t.toDate();
                  String request = appointmnet['status'];
                  String doctorname=appointmnet["doctorName"];
                  String ownername =appointmnet["ownerName"];
                  String appointmentid =snapshot.data!.docs[index].id;
                  String currentuser =appointmnet["ownerID"].toString();
                  String phone =appointmnet["phone"].toString();
                  String allergy =appointmnet["ownerAllergy"].toString();
                  String userName =appointmnet["ownerName"].toString();
                  String userAge =appointmnet["ownerAge"].toString();
                  String userWight =appointmnet["ownerWeight"].toString();
                  String userHeight =appointmnet["ownerHeight"].toString();
                  // appointmnet['ownerID'];
                  // snapshot.data.docs[index].reference.id.toString();
                  if(appointmnet["doctorID"]==userID && appointmnet["status"]!="pending"){ 
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
                            title:Text(ownername),                    
                            subtitle: Text(d.toString()),
                            contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                            trailing:  Wrap(spacing: 10,
                            children: <Widget>[ 
                                    if(request=="Accept")  
                                      ElevatedButton.icon(
                                        onPressed: (){
                                          print(appointmentid);
                                          createprescription(context,doctorname,appointmentid,currentuser,phone,allergy,userName,userAge,userWight,userHeight);}, 
                                        icon: Icon(Icons.medication,size: 30,color: Colors.black),
                                        label: Text(""),
                                        ) ,  
                                       
                                      // Text("Pending...",style: TextStyle(fontSize: 20),),         
                                    // if(request=="Accept")
                                    //   Icon(Icons.people_alt,size: 40,color: Colors.green.shade700),
                                    // if(request=="")
                                    //   Icon(Icons.unsubscribe,size: 40,color: Colors.black87)
                                  ],
                            ),
                            // snapshot.data[index]
                            onTap: ()=> navigateTodetail(docs[index]),
                          ),
                        ),
                    )
                      ;     
                    // return Center(child: Text("Don't have any information"),);
                  }
                  else{
                    return Center(child: Text(""),);
                  }
                }
                ); 
              }
                return Text("loading...");      
            });
}

Widget textpending(){
  return Container(
  margin: const EdgeInsets.all(15.0),
  // padding: const EdgeInsets.all(3.0),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black,width: 4),
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(20)
  ),
  padding:const EdgeInsets.all(15.0) ,
  child: Text('Patient Request',style: TextStyle(fontSize: 30),),
   );
}

Widget textshowappointment(){
  return Container(
  margin: const EdgeInsets.all(15.0),
  // padding: const EdgeInsets.all(3.0),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.black,width: 4),
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(20)
  ),
  padding:const EdgeInsets.all(15.0) ,
  child: Text('Patient Appointment',style: TextStyle(fontSize: 30),),
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
                mainAxisSize:  MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                textpending(),
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


class DetailsPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailsPage( {required this.post});
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  void initState(){
  super.initState();  
  // loadinfo();
}

Widget listappointmentdateinformation(){
  Timestamp t = widget.post["created"];
  DateTime d =t.toDate();
  String formatDate(DateTime dates) => new DateFormat.yMMMMd().format(dates);
  String formatTimes(DateTime dates) => new DateFormat.jm().format(dates);
  return Card(
    
    child:Container(
      // alignment:Alignment.bottomLeft ,
                  width: 360,
                  height: 560,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.black87),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column( 
                        // mainAxisAlignment: MainAxisAlignment.start,  
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
                           Wrap(
                            //  alignment: WrapAlignment.start,
                             children: [
                                Icon(Icons.person,color: Colors.white,),
                                Text(" Patient Name: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                 Text(widget.post["ownerName"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),
                           SizedBox(
                            height: 20,
                          ),
                            Wrap(children: [
                                Icon(Icons.cake,color: Colors.white,),
                                Text(" Age: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                Text(widget.post["ownerAge"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),        
                           SizedBox(
                            height: 20,
                          ),
                           Wrap(children: [
                                Icon(Icons.calendar_month,color: Colors.white,),
                                Text("  Date: ",style: TextStyle(color:Colors.white,fontSize: 20),),
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
                                Icon(Icons.bloodtype,color: Colors.white,),
                                Text(" Blood: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                Text(widget.post["ownerBlood"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),        
                           SizedBox(
                            height: 20,
                          ),
                          Wrap(children: [
                                Icon(Icons.people,color: Colors.white,),
                                Text("  Weight and Height: ",style: TextStyle(color:Colors.white,fontSize: 20),),
                                Text(widget.post["ownerWeight"]+", "+widget.post["ownerHeight"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]),        
                           SizedBox(
                            height: 20,
                          ),
                           Wrap(children: [
                                    Icon(Icons.sick,color: Colors.white,),
                                    Text(" Allergy:",style: TextStyle(fontSize: 20,color: Colors.white)),
                                    Text(widget.post["ownerAllergy"],style: TextStyle(color:Colors.white,fontSize: 20),),
                                  ]), 
                          SizedBox(
                            height: 20,
                          ),
                           Wrap(children: [
                                    Icon(Icons.health_and_safety,color: Colors.white,),
                                    Text(" Symtom    ",style: TextStyle(fontSize: 20,color: Colors.white)),
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
                
                   

  );
}

Widget displaytest(){
  return Text("show pending Appointment",style: TextStyle(fontSize: 100),);
}

//   @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(title:Text("Description"),
      backgroundColor: Colors.black),
         body:Container(
           child: SingleChildScrollView(
                        child: Column(
               children: [
                 listappointmentdateinformation(),
                  SizedBox(
                              height: 20,
                            ),
                  displaytest()
               ]
             ),
           )
         ),
        
    );
  }
}