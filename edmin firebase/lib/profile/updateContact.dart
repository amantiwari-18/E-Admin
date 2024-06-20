// ignore_for_file: camel_case_types, use_key_in_widget_constructors, file_names, avoid_unnecessary_containers, unused_local_variable, avoid_print, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:edmin/directioanal/makeAdmin/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

      if (userData.exists) {
        Map<String, dynamic>? userMap =
            userData.data() as Map<String, dynamic>?;

        if (userMap != null) {
          setState(() {
            userProfile = UserModel.fromMap(userMap);
            isLoading = false;
          });
        } else {
          // Handle the case where userMap is null
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // Handle the case where the document does not exist
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  void sd(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const UpdateProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       actions: [IconButton(icon: const Icon(Icons.update), onPressed: sd)],

        title: const Text("Profile"),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : userProfile != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userProfile.profilePic!),
                      ),
                      const SizedBox(height: 20),
                      _buildField("Name", userProfile.name),
                      _buildField("Email", userProfile.email),
                      _buildField("Phone", userProfile.phone),
                      _buildField("Designation", userProfile.designation),
                      _buildField("Division", userProfile.division),
                      _buildField("Extention", userProfile.extention),
                      _buildField("Telephone", userProfile.telephone),
                      // _buildField("Interests", userProfile.),
                    ],
                  )
                : const Center(
                    child: Text("Error loading profile."),
                  ),
      ),
    );
  }

  Widget _buildField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value ?? "-",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
