import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String fname = "";
  String lname = "";
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
                      // image: DecorationImage(
                      //     image: AssetImage("assets/images/bg.png"),
                      //     fit: BoxFit.cover)
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
                                    "assets/images/doctorphama.png",
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
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
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
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
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
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
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
                                validator: RequiredValidator(
                                    errorText: "Please fill this form"),
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
                                    )),
                                onSaved: (String? iname) {
                                  fname = iname!;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Lastname", style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                validator: RequiredValidator(
                                    errorText: "Please fill this form"),
                                decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blue),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1),
                                    ),
                                    focusedErrorBorder: new OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 3),
                                    )),
                                onSaved: (String? iname) {
                                  lname = iname!;
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SizedBox(
                                      width: 120,
                                      height: 50,
                                      child: ElevatedButton(
                                        child: Text("Sign in",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () async {
                                          if (formkey.currentState!
                                              .validate()) {
                                            formkey.currentState?.save();
                                            try {
                                              String? name =
                                                  fname + " " + lname;
                                              UserCredential result =
                                                  await FirebaseAuth
                                                      .instance
                                                      .createUserWithEmailAndPassword(
                                                          email: profile.email,
                                                          password:
                                                              profile.password);
                                              User? user = result.user;
                                              user?.updateDisplayName(name);
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Create account Successfully",
                                                  gravity: ToastGravity.TOP);
                                              FirebaseFirestore.instance
                                                  .collection('Profile')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .set({
                                                'name': name,
                                                'allergy': '',
                                                'age': '',
                                                'blood': '',
                                                'description': '',
                                                'height': '',
                                                'medicalcondition': '',
                                                'weight': '',
                                                'user_id': user?.uid,
                                                'picture':
                                                    "https://www.baxterip.com.au/wp-content/uploads/2019/02/anonymous.jpg"
                                              });
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
                                      )),
                                ),
                              ),
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
