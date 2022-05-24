import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_teamproject/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DoctorUserWidget extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final name = FirebaseAuth.instance.currentUser?.displayName;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Doctor")
          .where('doctorID', isEqualTo: auth.currentUser!.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: snapshot.data!.docs.map((document) {
            return Column(
              children: [
                Text(
                  document["doctorName"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  "${auth.currentUser!.email}",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
