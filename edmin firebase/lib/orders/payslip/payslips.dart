// ignore_for_file: unnecessary_null_comparison, camel_case_types, unnecessary_cast, use_super_parameters, use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:edmin/directioanal/dir.dart';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class PaySlips extends StatefulWidget {
  const PaySlips({Key? key}) : super(key: key);

  @override
  State<PaySlips> createState() => _PaySlipsState();
}

class _PaySlipsState extends State<PaySlips> {

  List<Map<String, dynamic>> pdfData = [];
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
 
 
  void getPDF() async {
    final result = await _firebaseFirestore.collection("Payslip").doc(uidd).collection('pdf').get();
    setState(() {
      pdfData = result.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    });
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
        title: const Text("PaySlips"),
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
            ));
          },
        ),
      ], // Added this closing bracket
    ),
//  ,
    );
  }
}
