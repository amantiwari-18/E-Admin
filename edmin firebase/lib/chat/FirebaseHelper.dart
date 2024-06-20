// import 'package:chatapp/models/UserModel.dart';
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:flutter/material.dart';

class FirebaseHelper {
  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }  
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;

    try {
      DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("user").doc(uid).get();

      if (docSnap.data() != null) {
        userModel = UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
      } else {
        
        // //print"getUserModelById: User data is null for UID: $uid");
      }
    } catch (e) {
      // //print"getUserModelById: Error fetching user data for UID: $uid - $e");
    }

    return userModel;
  }
}
