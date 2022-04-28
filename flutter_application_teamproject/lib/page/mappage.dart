import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_teamproject/model/place.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static GoogleMapController? _googleMapController;
  late GoogleMapController mapController;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _destinationCollection = FirebaseFirestore.instance.collection("destination");
  // final List<Place> places =[
  //   Place(fname: "Peem_opas",fsurname: "Opas",email: "Peem_opas@hptmail.com",password: "1234"),
  //   Place(fname: "Cream",fsurname: "Worada",email: "Cream@hptmail.com",password: "5555"),
  // ];

  final List<String> namesss = <String>
[
  "Peem","Opas","cream"
];


  var placecollection = [];
  Set<Marker> markers = Set();
  double lat=0,lng=0;
  var data;
  void initState() {
    super.initState();
    // showDestination();
    findLatLng();  
    // getplacesource();
  }
   Future<Null> findLatLng() async{
    LocationData? locationData = await findLocationData();
    setState(() {
      lat = locationData!.latitude!;
      lng = locationData.longitude!;
    });
    print("Hi lat =${lat}, lng =${lng}");
  }

  //   double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
//     double distance = 0;

//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
//     distance = 12742 * asin(sqrt(a));

//     return distance;
//   }

  Future<LocationData?> findLocationData() async{
    Location location =Location();
    try{
      return location.getLocation();
    }catch(e){
      return null;
    }
  }

  Widget showMapProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Location").snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> locationsnapshot) {
          if (locationsnapshot.hasData) {
            for(int i =0 ;i<locationsnapshot.data!.docs.length;i++){
              GeoPoint location = locationsnapshot.data?.docs[i]['location'];
              final latLng = LatLng(location.latitude, location.longitude);
               markers.add(Marker(markerId: MarkerId("location $i"),  position: latLng,
               infoWindow: InfoWindow(
                 title:"Pharmacy Store ${i+1}"
               ,snippet:'Doctor Name: ${i+1}' )));
                  _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 10.0
              ),

            )
          );

            }
      return FutureBuilder(
      future: firebase,
      builder: (context,snapshot){
        if (!snapshot.hasData){
           return Text("Got no data :(");
        }
        if(snapshot.hasError){
          return Scaffold(
            appBar:AppBar(title:Text("error")),
            body:Center(child: Text("${snapshot.error}"),)
          );
        }
        if(snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done){
          print("connect successfully");
          return SingleChildScrollView(
          child: Column(
            children: [  if(lat ==0)...[
                showMapProgress(),
            ] 
          else...[
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
          body: Center(child: CircularProgressIndicator())
          ,);
      }
      );
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



  // Widget _buildList2(){
  //   return StreamBuilder<QuerySnapshot>
  //   (stream: FirebaseFirestore.instance.collection("user").doc("user_id").collection("product").snapshots(),
  //   builder:)
  // }

  Widget _buildList(){
    return Container(
      height: 250,
      width: 500,
      child: StreamBuilder(
          stream:FirebaseFirestore.instance.collection("destination").snapshots(),
          builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(child:CircularProgressIndicator(),);
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                              child: ListView(
                  children:snapshot.data!.docs.map((document){
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
                        title:Text(document["name"]+document["fsurname"]),
                        subtitle: Text(document["email"]+" Km:" +document["score"]),
                        contentPadding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
                        // onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));},
                      ),
                    );
                  }).toList(),         
                ),
              ),
            );
          },
       ),
    );
  }

  // Widget _builList(){
  //   return Container(
  //     height: 100,
  //     width: 500,
  //     child: ListView.builder(
  //       itemCount:namesss.length,
  //       itemBuilder: (context,index){
  //         return ListTile(
  //           title: Text(namesss[index].toString()),
  //         );
  //       }
  //       ),
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
    return Container
    (width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
          color: Colors.black,
          onPressed: (){
            
          },
          icon:Icon(Icons.save,color: Colors.white,),
          label: Text("Save information",style: TextStyle(color: Colors.white),),
          ),
    );
  }

  void _onMapCreated(GoogleMapController controller){
   mapController =controller;
  }

  Widget showMap() { 
    LatLng latlng =LatLng(lat, lng);
    CameraPosition cameraPosition =CameraPosition(
      target: latlng,
      zoom: 14.0,);
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