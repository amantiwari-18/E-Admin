// ignore_for_file: unnecessary_null_comparison, use_super_parameters, unnecessary_cast, use_build_context_synchronously

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
class GovtNotice extends StatefulWidget {
  const GovtNotice({Key? key}) : super(key: key);

  @override
  State<GovtNotice> createState() => _GovtNoticeState();
}

class _GovtNoticeState extends State<GovtNotice> {
  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<Map<String, dynamic>> pdfData = [];
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<String?> uploadPDF(String fileName, File file) async {
    final ref = FirebaseStorage.instance.ref().child("Govt Order/$fileName.pdf");
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() => {});
    final downloadLink = await ref.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    if (titleController.text == "") {
      showErrorMessage(context, "PLEASE ENTER THE TITLE");
    } else {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
      );

      if (pickedFile != null) {
        String fileName = pickedFile.files[0].name;
        File file = File(pickedFile.files[0].path!);

        final downloadLink = await uploadPDF(fileName, file);

        await _firebaseFirestore.collection("Govt Order").add({
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
  }

  void getPDF() async {
    final result = await _firebaseFirestore.collection("Govt Order").get();
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
        title: const Text("Goverment Order"),
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/aries_logo_auto_6_3_1.png",
              fit: BoxFit.cover,
            ),
          ),
          GridView.builder(
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


                   onTap: ()async{                           Map<Permission, PermissionStatus> statuses = await [
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
                          content: Text("File Downloaded"),

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
                     content: Text("File Saved In Downloads"),
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
                ),
              );
            },
          ),
        ],
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
                                  decoration: const InputDecoration(labelText: 'Title *'),
                                ),
                                TextField(
                                  controller: descriptionController,
                                  decoration: const InputDecoration(labelText: 'Description'),
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
