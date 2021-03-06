import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/page/loginpage.dart';
import 'package:flutter_application_teamproject/page/registerpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register/Login"),
      backgroundColor: Colors.black,
      ),
      body: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

        child: Container(
          height: 700,
          decoration: BoxDecoration(
            image:  DecorationImage(image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover)
          //  borderRadius: BorderRadius.circular(20),
          //  color: Colors.blue[100] ,
          //  border: Border.all(
          //    color: Colors.blue,
          //    width:12,
          //  )
           
          ),
       
          child: SingleChildScrollView(
              child: Column(
              children:[
                SizedBox(height: 10,),
                Image.asset("assets/images/doctorphama.png"),
                SizedBox(height: 20,),
                Image.asset("assets/images/medicine.png",height: 70,),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text("The most worldwide medicine app that will provide the best soluton for Patient"
                  ,style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),textAlign:TextAlign.center,),
                ),
                // SizedBox(height: 10,),
                // Image.asset("assets/images/pharmacy.png",height: 70,),
                // Padding(
                //   padding: const EdgeInsets.all(30),
                //   child: Text("The most worldwide medicine app that will provide the best soluton for customer"
                //   ,style: TextStyle(fontSize: 20,color: Colors.black),),
                // ),
                SizedBox(height: 30,),

                  SizedBox(
                  width: 300,
                  child: ElevatedButton.icon(
                  icon: Icon(Icons.login), 
                  label: Text("Login",style:TextStyle(fontSize:20)),
                  onPressed:(){
                     Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return LoginPage();
                    }));
                  }, 
                        style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0), 
                        side: BorderSide(color: Colors.black87)                                
  )
),
                  )
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                  width: 300 ,
                  child: ElevatedButton.icon(
                  icon: Icon(Icons.add), 
                  label: Text("Create the account",style:TextStyle(fontSize:20)),
                        style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0), 
                        side: BorderSide(color: Colors.black87)                          
  )
),  
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return RegisterPage();
                    }));
                  },
                  )
                  ),
                  SizedBox(height: 10,),



            ]),


          ),
        ),
      ),
    );
  }
}