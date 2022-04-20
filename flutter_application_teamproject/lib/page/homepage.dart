import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Container(
            height: 1000,
            width: 500,
            decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg2login.png"),
                          fit: BoxFit.cover)
                      ),
            child: Center(
              child: Column(       
                children:[
                  Text("Welcome to our home page"),
                  Text("Email information: ${auth.currentUser!.email}",
                  style: TextStyle(fontSize: 20),),

                  ElevatedButton(onPressed: (){
                    auth.signOut().then((value){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return HomePage();
                      }));
                    } );
                  }, child: Text("log out"))
                ]
              ),
            ),
          ),
        ),
      );
  }
}