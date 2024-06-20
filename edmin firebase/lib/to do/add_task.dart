// ignore_for_file: camel_case_types, avoid_unnecessary_containers, unused_local_variable, use_super_parameters, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added Firestore import

class add_task extends StatefulWidget {
  const add_task({Key? key}) : super(key: key);

  @override
  State<add_task> createState() => _add_taskState();
}

class _add_taskState extends State<add_task> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Update this function to handle errors
  Future<void> addTaskToFirestore() async {
    try {
      await Firebase.initializeApp(); // Initialize Firebase if not already done
      FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      if (user != null) {
        var time = DateTime.now();
        await FirebaseFirestore.instance
            .collection('task')
            .doc(user.uid)
            .collection('mytasks')
            .doc(time.toString())
            .set({
          'title': titleController.text,
          'description': descriptionController.text,
          'time': time.toString(),
        });

        Fluttertoast.showToast(msg: "Data Added");
      } else {
        Fluttertoast.showToast(msg: "User not authenticated");
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: $error");
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Title",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Description",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: const Text("Add Task"),
                onPressed: () {
                  addTaskToFirestore();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
