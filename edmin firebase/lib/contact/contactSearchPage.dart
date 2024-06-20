// ignore_for_file: camel_case_types, use_key_in_widget_constructors, file_names, avoid_unnecessary_containers, unused_local_variable, avoid_print, use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:edmin/contact/viewContact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class searchPage extends StatefulWidget {
  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  con(UserModel model){

  // String name =nameController.toString();
  String? uid = model.uid; 
        Navigator.push(context, MaterialPageRoute(builder: (context) => viewContact(SrchUID: uid,) ));

  }
    void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }  

  void search() async {
    User? credential = FirebaseAuth.instance.currentUser;
    String? uid = credential?.uid;

    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();

    if (userData.exists) {
      Map<String, dynamic>? userMap =
          userData.data() as Map<String, dynamic>?;

      if (userMap != null) {
        UserModel userModel = UserModel.fromMap(userMap);
        setState(() {});
      } else {
         showErrorMessage(context,"NO USER ");
        
      }
    } else {
         showErrorMessage(context,"USER NOT FOUND ");

    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        // actions: const [],
        title: const Text("SEARCH"),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/aries_logo_auto_6_3_1.png"))),

          child: Column(children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: "NAME"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  
                });
              },
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .where("name", isEqualTo: searchController.text.toUpperCase())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) { 
                    QuerySnapshot dataSnapshot =
                        snapshot.data as QuerySnapshot;

                    if (dataSnapshot.docs.isNotEmpty) {
                      return Column(
                        children: dataSnapshot.docs
                            .map((QueryDocumentSnapshot document) {
                          Map<String, dynamic> userMap =   document.data() as Map<String, dynamic>;
                          UserModel searchedUser =  UserModel.fromMap(userMap);
                          return ListTile( 
                             trailing: IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right),
                    onPressed:()
                    {
                      
                             con(searchedUser);
                    }
                            ),
                            leading: CircleAvatar(backgroundImage: NetworkImage(searchedUser.profilePic!)),
                            title: Text(searchedUser.name!.toString()),
                            subtitle: Text(searchedUser.email!.toString()),
                          );
                        }).toList(),
                      );
                    } else {
                      return const Text("NO RESULT FOUND");
                    }
                  } else if (snapshot.hasError) {
                    return const Text("AN ERROR OCCURRED");
                  } else {
                    return const Text("NO RESULT FOUND");
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
