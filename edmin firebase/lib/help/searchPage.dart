// ignore_for_file: camel_case_types, use_key_in_widget_constructors, avoid_unnecessary_containers, use_build_context_synchronously, file_names

// import 'dart:math'; // Add this import for uuid

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:edmin/chat/chatModel.dart';
import 'package:edmin/chat/chatRoom.dart';
import 'package:edmin/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import your model classes and other dependencies

class searchPage extends StatefulWidget {
  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    User? credential = FirebaseAuth.instance.currentUser;
    String? uid = credential?.uid; 

    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("help")
        .where("participants.$uid", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("help")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;
    }

    return chatRoom;
  }

  // TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HELP DESK"),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // TextField(
                // controller: searchController,
                // decoration: const InputDecoration(labelText: "Name"),
              // ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // setState(() {});

                  
                  // Handle search functionality if needed
                },
                child: const Text("ALL THE HELPERS ARE BELOW"),
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .where("name", isEqualTo: "E ADMIN HELPER")
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
                              onTap: () async {
                                ChatRoomModel? chatroomModel =
                                    await getChatroomModel(searchedUser);

                                if (chatroomModel != null) {
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ChatRoomPage(
                                            targertUser: searchedUser,
                                            userModel: searchedUser,
                                            credential: FirebaseAuth.instance.currentUser,
                                            chatRoom: chatroomModel,
                                          );
                                        },
                                      ));
                                }
                              },
                               leading: CircleAvatar(backgroundImage: NetworkImage(searchedUser.profilePic!)),
                              title: Text(searchedUser.name??""),
                              subtitle: Text(searchedUser.email??"" ),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text("No results found!");
                      }
                    } else if (snapshot.hasError) {
                      return const Text("An error occurred!");
                    } else {
                      return const Text("No results found!");
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

