// ignore_for_file: file_names, camel_case_types, avoid_unnecessary_containers, use_super_parameters, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:edmin/help/chatModel.dart';
import 'package:edmin/help/messageModel.dart';
import 'package:edmin/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../directioanal/dir.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targertUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User? credential;

  const ChatRoomPage({
    Key? key,
    required this.userModel,
    this.credential,
    required this.targertUser,
    required this.chatRoom,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController msgController = TextEditingController();

  void sendMessage() async {
    String msg = msgController.text.trim();
    msgController.clear();
    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: uidd,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
        reciver: widget.targertUser.uid.toString(),
      );

      FirebaseFirestore.instance
          .collection("help")
          .doc(widget.chatRoom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("help")
          .doc(widget.chatRoom.chatroomid)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(widget.targertUser.profilePic!)),
            const SizedBox(
              width: 10,
            ),
            Text(widget.targertUser.name.toString()),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("help")
                        .doc(widget.chatRoom.chatroomid)
                        .collection("messages")
                        .orderBy("createdon", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(
                                      dataSnapshot.docs[index].data()
                                          as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: (currentMessage.sender == uidd)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (currentMessage.sender == uidd)
                                          ? const Color.fromARGB(255, 12, 12, 12)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: const Color.fromARGB(255, 11, 11, 11)),
                                    ),
                                    child: Text(
                                      currentMessage.text.toString(),
                                      style: TextStyle(
                                        color: (currentMessage.sender == uidd)
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                "An error occurred! Please check your internet connection."),
                          );
                        } else {
                          return const Center(
                            child: Text("Say hi to your new friend"),
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
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: msgController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter message",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Color.fromARGB(255, 233, 230, 230)),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Color.fromARGB(255, 251, 251, 251),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
