import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/data/menu_items.dart';
import 'package:flutter_application_teamproject/model/meun_item.dart';
import 'package:flutter_application_teamproject/page/profilepage.dart';
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
      appBar: AppBar(title: Text("Welcompage"),
      actions: [
        
        PopupMenuButton<MenuItem>(
          onSelected: (item)=>onSelected(context,item),
          itemBuilder: (context)=>[
           ...MenuItems.itemFirst.map(buildItem).toList(),  
           PopupMenuDivider(),
           ...MenuItems.itemSecond.map(buildItem).toList(),  
        ],
         
        )
      ],
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
  PopupMenuItem<MenuItem> buildItem(MenuItem item) => 
  PopupMenuItem<MenuItem>(
    value:item,
    child: Row(children: [
    Icon(item.icon,color:Colors.black,size:20),
    const SizedBox(width:12),
    Text(item.text)
    ],)
    );

  void onSelected(BuildContext context,MenuItem item){
    switch (item){
      case MenuItems.itemSetting:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> ProfilePage())
          );
          break;

      case MenuItems.itemSignout:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=> HomePage())
          );
          break;
      
    }
  }
}