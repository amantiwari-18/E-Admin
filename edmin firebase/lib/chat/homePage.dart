// ignore_for_file: avoid_unnecessary_containers, camel_case_types, use_key_in_widget_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:edmin/chat/FirebaseHelper.dart';
import 'package:edmin/chat/chatModel.dart';
import 'package:edmin/chat/chatRoom.dart';
import 'package:edmin/chat/searchPage.dart';
import 'package:edmin/directioanal/dir.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  
//  void showErrorMessage(BuildContext context, String message) {
//     final snackBar = SnackBar(
//       content: Text(
//         message,
//         style: const TextStyle(fontSize: 16),
//       ),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   } 
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAT"),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/aries_logo_auto_6_3_1.png"))),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.$uidd", isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot = snapshot.data!;
                  
                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data() as Map<String, dynamic>);

                      Map<String, dynamic> participants = chatRoomModel.participants!;
                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(uidd);

                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState == ConnectionState.done) {
                                                        
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChatRoomPage(
                                        chatRoom: chatRoomModel,
                                        credential: FirebaseAuth.instance.currentUser,
                                        userModel: targetUser,
                                        targertUser: targetUser,
                                      );
                                    }),
                                  );
                                },
                                leading: CircleAvatar(backgroundImage: NetworkImage(targetUser.profilePic!)),
                                title: Text(targetUser.name.toString()),
                                subtitle: (chatRoomModel.lastMessage.toString() != "")
                                    ? Text(chatRoomModel.lastMessage.toString())
                                    : const Text(
                                        "Say hi to your new friend!",
                                      ),
                              );
                            } 
                            else {
                              // showErrorMessage(context, "NO USER FOUND");

                              return Container(
                                // child: const Text("Error fetching user data"),
                              );
                            }
                          } else {
                            return Container(
                              child: const CircularProgressIndicator( strokeAlign:0),
                            );
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("No Chats"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => searchPage()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
