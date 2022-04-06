import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
   return FutureBuilder(
      future:firebase,
      builder: (context,snapshot)
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
                  appBar: AppBar(title: Text("LoginPage"),),
                  body:Container(
                  child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                  key: formkey,
                  child:SingleChildScrollView(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Email",style:TextStyle(fontSize: 20)),
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
                Text("Password",style:TextStyle(fontSize: 20)),
                TextFormField(
                  validator: RequiredValidator(errorText: "Pls fill the correct password"),
                  obscureText: true,
                   onSaved:(String? password){
                    profile.password = password!;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text("Login"),
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
                  )
            ],),
          )),
        )
      ),
    );
        }


        return Scaffold(
          body:Center(
            child: CircularProgressIndicator(),
            ),
        );
    });
  }
}