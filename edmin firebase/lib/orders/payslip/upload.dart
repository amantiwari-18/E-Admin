// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class uploadPay extends StatefulWidget {
  const uploadPay({super.key});

  @override
  State<uploadPay> createState() => _uploadPayState();
}

class _uploadPayState extends State<uploadPay> {
  List<Map<String, dynamic>> pdfData = [];
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
 final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<String?> uploadPDF(String fileName, File file) async {
    final ref = FirebaseStorage.instance.ref().child("Payslip/$fileName.pdf");
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => {});
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  void pickFile(String uid) async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf", "png", "jpeg"],
    );

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);

      final downloadLink = await uploadPDF(fileName, file);

      await _firebaseFirestore.collection("Payslip").doc(uid).collection('pdf').add({
        "name": fileName,
        "url": downloadLink,
        "title": titleController.text,
        "description": descriptionController.text,
        "timestamp": FieldValue.serverTimestamp(),
      });

      titleController.clear();
      descriptionController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SEARCH"),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/aries_logo_auto_6_3_1.png"))),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(labelText: "Name"),
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
                              onTap: () async {
                                 showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Upload File'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: titleController,
                                  decoration: const InputDecoration(labelText: 'Title'),
                                ),
                                TextField(
                                  controller: descriptionController,
                                  decoration: const InputDecoration(labelText: 'Description'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    pickFile(searchedUser.uid.toString());
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Upload'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                              // pickFile(searchedUser.uid.toString());
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