import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_teamproject/page/startpage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static GoogleMapController? _googleMapController;
  late GoogleMapController mapController;
  String query = "";
  String distanceString = "";
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _destinationCollection =
      FirebaseFirestore.instance.collection("destination");
  // final List<Place> places =[
  //   Place(fname: "Peem_opas",fsurname: "Opas",email: "Peem_opas@hptmail.com",password: "1234"),
  //   Place(fname: "Cream",fsurname: "Worada",email: "Cream@hptmail.com",password: "5555"),
  // ];
  Completer<GoogleMapController> _controller = Completer();
  final _textcontroller = TextEditingController(text: "");
  Set<Marker> markers = Set();
  double lat = 0, lng = 0, distance = 0;
  var data;
  void initState() {
    super.initState();
    // showDestination();
    findLatLng();

    // getplacesource();
  }

  Future<Null> findLatLng() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat = locationData!.latitude!;
      lng = locationData.longitude!;
    });
    print("Hi lat =${lat}, lng =${lng}");
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    var myformat = NumberFormat('#0.0#', 'en_us');
    distanceString = myformat.format(distance);
    return distance;
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Widget showMapProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Location").snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> locationsnapshot) {
          if (locationsnapshot.hasData) {
            for (int i = 0; i < locationsnapshot.data!.docs.length; i++) {
              String doctorName = locationsnapshot.data?.docs[i]['doctorName'];
              String storeName = locationsnapshot.data?.docs[i]['storeName'];
              GeoPoint location = locationsnapshot.data?.docs[i]['location'];
              final latLng = LatLng(location.latitude, location.longitude);
              distance = calculateDistance(
                  lat, lng, location.latitude, location.longitude);
              print("Distance $i : $distance");
              _destinationCollection
                  .doc('Test${i + 1}')
                  .update({"distance": distanceString});
              markers.add(Marker(
                  markerId: MarkerId("location $i"),
                  position: latLng,
                  infoWindow: InfoWindow(
                      title: "Pharmacy Store: ${storeName}",
                      snippet: 'Doctor Name: ${doctorName}')));
              _googleMapController
                  ?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: latLng, zoom: 10.0),
              ));
            }
            return FutureBuilder(
                future: firebase,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Got no data :(");
                  }
                  if (snapshot.hasError) {
                    return Scaffold(
                        appBar: AppBar(title: Text("error")),
                        body: Center(
                          child: Text("${snapshot.error}"),
                        ));
                  }
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    print("connect successfully");
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          if (lat == 0) ...[
                            showMapProgress(),
                          ] else ...[
                            showMap(),
                            saveButton(),
                            _buildList()
                          ]
                          // lat == 0 ? showMapProgress() :
                          // showMap(),
                          // saveButton(),
                        ],
                      ),
                    );
                  }
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  // void getplacesource(){
  //   _destinationCollection.doc().get().then((snapshot)
  //   {
  //     setState(() {
  //       placecollection.addAll([
  //         Place(
  //           fname: snapshot["name"],
  //           fsurname: snapshot["fsurname"],
  //           email: snapshot["email"],
  //           password: snapshot["password"]
  //         )]
  //       );
  //       print(placecollection);
  //     });
  //   });
  // }
  Widget _buildList() {
    return Container(
      height: 200,
      width: 500,
      child: StreamBuilder<QuerySnapshot>(
        stream: _destinationCollection.snapshots().asBroadcastStream(),
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            if(snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['clinicName']
                .toString().toLowerCase().contains(query.toLowerCase())).isEmpty){
                  return Center(child:Text("No data found"));
                }
              else{
                 return Card(
                                    child: ListView(
              children:[
                ...snapshot.data!.docs.where((QueryDocumentSnapshot<Object?> element) => element['clinicName']
                .toString().toLowerCase().contains(query.toLowerCase())
                ).map((QueryDocumentSnapshot<Object?> data){
                      final String lname =data["clinicName"];
                       final String lsurname =data["doctorName"];
                       final String ldistance =data["distance"].toString();

                       return Container(
                          margin:EdgeInsets.all(20),
                         child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: 
                            BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black)),
                            leading:CircleAvatar(
                              radius:30,
                              child:FittedBox(child: Icon(Icons.place)
                              ,)
                            ),
                           title: Text(lname + " Doctor: "+lsurname),
                          subtitle:Text(" Distance:" + ldistance+" km"),
                            contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                            // onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));},
                            onTap: (){},
                         ),
                       );
                })
              ]

              
            ),
                 );
              }
            }
          }),
    );
  }

  // Widget _buildList(){
  //   return Container(
  //     height: 250,
  //     width: 500,
  //     child: StreamBuilder(
  //         stream:FirebaseFirestore.instance.collection("destination").snapshots(),
  //         builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
  //           if(!snapshot.hasData){
  //             return Center(child:CircularProgressIndicator(),);
  //           }
  //           return Padding(
  //             padding: const EdgeInsets.all(10.0),
  //             child: Card(
  //                             child: ListView(
  //                 children:snapshot.data!.docs.map((document){
  //                    final String lname =document["name"];
  //                    final String lsurname =document["fsurname"];
  //                    final String ldistance =document["distance"].toString();
  //                   return Container(
  //                     margin:EdgeInsets.all(20),
  //                     child: ListTile(
  //                       shape: RoundedRectangleBorder(borderRadius:
  //                       BorderRadius.circular(10),
  //                       side: BorderSide(color: Colors.black)),
  //                       leading:CircleAvatar(

  //                         radius:30,
  //                         child:FittedBox(child: Icon(Icons.place)
  //                         ,)
  //                       ),
  //                      title: Text(lname + lsurname),
  //                     subtitle:Text(" Distance:" + ldistance+" km"),
  //                       contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
  //                       // onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));},
  //                       onTap: (){

  //                       },
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //           );
  //         },
  //      ),
  //   );
  // }

  // Widget showDestination() {
  //   return Container(
  //     child:Column(
  //       children: [
  //         ListTile(
  //                 leading:CircleAvatar(
  //                 radius:50,
  //                 child:FittedBox(child: Text("score")
  //                     ,)
  //                   ),
  //                 title:Text("name"+"fsurname"),
  //                 subtitle: Text("email"),
  //                 onTap: ()=>print("Listtile"),
  //                 ),
  //         SizedBox(height:10 ),
  //       ],
  //     ),
  //     );
  //   }

  Widget saveButton() {
    //  final _textcontroller =TextEditingController(text: "");
    return Container(
      width: 350,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          // color: Colors.black54,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: _textcontroller,
          onChanged: (value) {
            if (value != "") {
              String texts = value;
              // query=value;
              setState(() {
                this.query = texts;
                //  this._textcontroller.text = query;
              });
            }
            // _textcontroller.text = query;
          },
          decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _textcontroller.clear();
                },
              )),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget showMap() {
    LatLng latlng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latlng,
      zoom: 14.0,
    );
    return Container(
      margin: const EdgeInsets.all(16),
      height: 250,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        markers: markers,
      ),
    );
  }
}
