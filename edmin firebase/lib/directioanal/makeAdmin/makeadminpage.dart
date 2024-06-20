// ignore_for_file: camel_case_types, use_key_in_widget_constructors, file_names, avoid_unnecessary_containers, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MAKEADMINsearchPage extends StatefulWidget {
  @override
  State<MAKEADMINsearchPage> createState() => _MAKEADMINsearchPageState();
}

class _MAKEADMINsearchPageState extends State<MAKEADMINsearchPage> {
  void makeAdmin(UserModel user) async {
    // Update the user's admin status to true in the database
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .update({'admin': true});

    // Print a message for demonstration purposes
    print('${user.name} is now an admin.');

    // Update the UI or show a notification as needed
    setState(() {});
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
        // print"userMap is null");
      }
    } else {
      // print"Document does not exist");
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SEARCH"),
      ),
      body: SafeArea(
        child: Container(
          child: Column(children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: "NAME"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
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
                          Map<String, dynamic> userMap =
                              document.data() as Map<String, dynamic>;
                          UserModel searchedUser =
                              UserModel.fromMap(userMap);
                          return ListTile(
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(searchedUser.profilePic!)),
                            onTap: () {
                              // Show the option to make admin when the user is tapped
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Make Admin'),
                                    content: const Text(
                                        'Do you want to make this user an admin?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          makeAdmin(searchedUser);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Make Admin'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
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
