import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/contact/contactSearchPage.dart';
import 'package:edmin/contact/viewContact.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  User? user = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot<Map<String, dynamic>>> getContacts() {
    return FirebaseFirestore.instance
        .collection("user")
        .orderBy("name")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CONTACTS"),
      ),
      body: Stack(
        children: [
          // Background Image
        Center(

         child: Image.asset(
           "assets/aries_logo_auto_6_3_1.png", // Replace with your image asset path
            fit: BoxFit.cover,
           
        ) 
          ),
          // Main Content
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getContacts(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                showErrorMessage(context, "SOMETHING WENT WRONG");
                return const Text("SOMETHING WENT WRONG");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("LOADING"),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No contacts available."),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map(
                  (DocumentSnapshot<Map<String, dynamic>> document) {
                    Map<String, dynamic> data = document.data()!;
                    String srchuid = data.containsKey("uid")
                        ? data["uid"].toString()
                        : "";
                    String phone =
                        data.containsKey("phone") ? data["phone"].toString() : "";
                    String profilePic =
                        data.containsKey("profilePic") ? data["profilePic"].toString() : "";
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(77, 85, 228, 0.2),
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => viewContact(
                              SrchUID: srchuid,
                            ),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(profilePic),
                        ),
                        title: Text(data["name"]),
                        subtitle: Text(phone),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => searchPage()),
          );
        },
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
