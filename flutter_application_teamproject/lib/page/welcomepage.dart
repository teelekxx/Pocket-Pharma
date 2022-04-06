import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("hi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
      )
    );
  }
}