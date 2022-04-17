import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/model/profile.dart';
import 'package:flutter_application_teamproject/page/startpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  final formkey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot}"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("registerpage"),
                backgroundColor: Colors.black,
              ),
              body: Container(
                  height: 700,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg.png"),
                          fit: BoxFit.cover)
                      //  borderRadius: BorderRadius.circular(20),
                      //  color: Colors.blue[100] ,
                      //  border: Border.all(
                      //    color: Colors.blue,
                      //    width:12,
                      //  )

                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Form(
                        key: formkey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                    "assets/images/pocketphamaw.png",
                                    height: 100),
                              ),
                              Text("Email", style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                validator: MultiValidator([
                                  RequiredValidator(
                                    errorText: "Please fill this form",
                                  ),
                                  EmailValidator(
                                      errorText:
                                          "Please fill the correct email form"),
                                ]),
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (String? email) {
                                  profile.email = email!;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Password", style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _pass,
                                validator: RequiredValidator(
                                    errorText: "Please fill this form"),
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                obscureText: true,
                                onSaved: (String? password) {
                                  profile.password = password!;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Confirm Password",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _confirmPass,
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return 'Please fill this form';
                                  if (val != _pass.text)
                                    return 'Password does not match';
                                  return null;
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    errorStyle: TextStyle(color: Colors.red),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                obscureText: true,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Firstname", style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _pass,
                                validator: RequiredValidator(
                                    errorText: "Please fill this form"),
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                obscureText: true,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Lastname", style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _pass,
                                validator: RequiredValidator(
                                    errorText: "Please fill this form"),
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                obscureText: true,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                    ),
                                    child: Text("Sign Up"),
                                    onPressed: () async {
                                      if (formkey.currentState!.validate()) {
                                        formkey.currentState?.save();
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Create account Successfully",
                                              gravity: ToastGravity.TOP);
                                          formkey.currentState?.reset();
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return HomePage();
                                          }));
                                        } on FirebaseAuthException catch (e) {
                                          //  print(e.message);
                                          //  print(e.code);
                                          Fluttertoast.showToast(
                                              msg: e.message!,
                                              gravity: ToastGravity.CENTER);
                                        }
                                      }
                                    },
                                  ))
                            ],
                          ),
                        )),
                  )),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
