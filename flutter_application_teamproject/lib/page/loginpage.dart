import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/page/registerpage.dart';
import 'package:flutter_application_teamproject/page/welcomepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_application_teamproject/model/profile.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formkey = GlobalKey<FormState>();
  Profile profile =Profile(email: '',password: '');
  final Future<FirebaseApp> firebase =Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
   return  FutureBuilder(
      future:firebase,
      builder:(context,snapshot)
      {
        if(snapshot.hasError){
          return Scaffold(
            appBar:AppBar(
              title: Text("Error"),
          ),
          body:Center(
            child: Text("${snapshot}"),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
           return Scaffold(
                  appBar: AppBar(title: Text("LoginPage"), 
                  backgroundColor: Colors.black,),



                  body:Padding(  
                    padding: const EdgeInsets.all(0),     
                    child: Container(  
                    height: 1000,                
                    decoration: BoxDecoration(
                    image:  DecorationImage(image: AssetImage("assets/images/bg2login.png"),
                    fit: BoxFit.cover)
          //  borderRadius: BorderRadius.circular(20),
          //  color: Colors.blue[100] ,
          //  border: Border.all(
          //    color: Colors.blue,
          //    width:12,
          //  )
           
          ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                        key: formkey,
                        child:SingleChildScrollView(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [  SizedBox(height: 10,),
                          Image.asset("assets/images/pocketphamaw.png"),
                          SizedBox(height: 20,),
                          Wrap(children:[
                            Icon(Icons.email),
                            Text("  Email",style:TextStyle(fontSize: 20))
                          ]
                            ),                          
                          TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Pls fill the form"),
                          EmailValidator(errorText: "Pls fill the correct email form"),
                          ]         
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved:(String? email){
                          profile.email =email!;
                        },
                ),
                SizedBox(height: 15,),
                Wrap(children:[
                            Icon(Icons.usb),
                            Text("  Password",style:TextStyle(fontSize: 20))
                          ]
                            )
                ,
                TextFormField(
                        validator: RequiredValidator(errorText: "Pls fill the correct password"),
                        obscureText: true,
                         onSaved:(String? password){
                          profile.password = password!;
                        },
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                            width: 120,
                            height: 50,
                            child: ElevatedButton(
                            child: Text("Sign in"),
                        
                            style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0), 
                            side: BorderSide(color: Colors.black87)                          
  )
),  
                              
                              onPressed: () async{
                                  if(formkey.currentState!.validate()){
                                      formkey.currentState?.save();
                                    try{
                                       await FirebaseAuth.instance.signInWithEmailAndPassword(
                                         email: profile.email, 
                                         password: profile.password
                                         ).then((value){
                                           formkey.currentState?.reset();
                                            Navigator.pushReplacement(
                                            context,MaterialPageRoute(builder: (context){
                                            return WelcomePage();
                                      })
                                      );
                                         });
                                    
                                    }on FirebaseAuthException catch(e){
                                      //  print(e.message);
                                      //  print(e.code);
                                        Fluttertoast.showToast(
                                        msg: e.message!,
                                        gravity: ToastGravity.CENTER
                                      );
                                    }
                                  }   
                              },)
                            ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                  children :[  
                    Text("Don't have an account?,",style: TextStyle(fontSize: 20),),
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(
                      context,MaterialPageRoute(builder: (context){
                      return RegisterPage();
                      })
                    );
                    }, child:Text("Sign up",style: 
                    TextStyle(
                      color: Colors.black,
                      fontSize: 20),) 
                      )         
                  ]
                )
                ),
            ],
            ),
          )
          ),
                      ),
                    ),
                      ),                 
                  ),
    );
        }
        return Scaffold(
          body:Container(
            
            child: CircularProgressIndicator(),
            
            ),
        );
    });
  }
}