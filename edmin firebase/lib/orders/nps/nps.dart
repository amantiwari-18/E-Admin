// ignore_for_file: unnecessary_null_comparison, use_super_parameters, unnecessary_cast, prefer_const_constructors, camel_case_types, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class npsUpdate extends StatefulWidget {
  const npsUpdate({Key? key}) : super(key: key);

  @override
  State<npsUpdate> createState() => _npsUpdateState();
}

class _npsUpdateState extends State<npsUpdate> {
 
 
 List<Map<String, dynamic>> pdfData = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<String?> uploadPDF(String fileName, File file) async {
   
    final ref = FirebaseStorage.instance.ref().child("NPS/$fileName.pdf");
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => {});
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);

      final downloadLink = await uploadPDF(fileName, file);

      await _firebaseFirestore.collection("NPS").add({
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

  void getPDF() async {
    final result = await _firebaseFirestore.collection("NPS").get();
    setState(() {
      pdfData = result.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    });
  }

  Future<bool> isAdmin() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return false;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      bool isAdmin = userDoc['admin'] ?? false;

      return isAdmin;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NPS"),
      ),
      body:  Stack(
      children: [
        // Background Image
        Center(child: 
        Image.asset(
          "assets/aries_logo_auto_6_3_1.png", // Replace with your image asset path
          fit: BoxFit.cover,
          // width: double.infinity,
          // height: double.infinity,
        )
        ), GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: pdfData.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime dateTime = (pdfData[index]['timestamp'] as Timestamp).toDate();
          String formattedDateTime = "${dateTime.toLocal()}".split('.')[0];
return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                           Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();

                  if(statuses[Permission.storage]!.isGranted){
                    var dir = await DownloadsPathProvider.downloadsDirectory;
                    if(dir != null){
                      String savename =  pdfData[index]['name'];
                      String savePath = "${dir.path}/$savename";
                      // print(savePath);
                      try {
                        // print("inn");
                        await Dio().download(
                            pdfData[index]['url'],
                            savePath,
                          
                            );
                        // print("File is saved to download folder.");
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("File Saved In Downloads"),
                        ));
                        OpenFile.open(savePath);

                      } 
                      catch(e) {
                        // print(e.message);
                      }
                    }
                  }else{
                    // print("No permission to read and write.");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Permission Denied !"),
                    ));
                  }
                },
             
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.insert_drive_file, size: 48.0, color: Colors.blue),
                  Text(
                    pdfData[index]['title'] ?? 'No Title',
              
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    formattedDateTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                        ),
                    ),
                    
                ],
              ),
            ));
          },
        ),
      ], // Added this closing bracket
    ),
      floatingActionButton: FutureBuilder<bool>(
        future: isAdmin(),
        builder: (context, isAdminSnapshot) {
          if (isAdminSnapshot.connectionState == ConnectionState.done) {
            bool isAdmin = isAdminSnapshot.data ?? false;

            return isAdmin
                ? FloatingActionButton(
                    onPressed: () {
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
                             
                                ElevatedButton(
                                  onPressed: () {
                                    pickFile();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Upload'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.add),
                  )
                : Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
