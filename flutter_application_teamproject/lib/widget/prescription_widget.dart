import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class PrescriptionWidget extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final name = FirebaseAuth.instance.currentUser?.displayName;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("prescription")
          .where('patientID', isEqualTo: auth.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: snapshot.data!.docs.map((document) {
            return Card(
              child: ListTile(
                title: Text(document["createBy"]),
                subtitle: Text("Prescriptions: \n- " +
                    document["rxPrescription"] +
                    "\n"
                        "Phone: " +
                    document["phone"] +
                    "\n"
                        "Date: " +
                    document["dateTime"].toDate().toString()),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
