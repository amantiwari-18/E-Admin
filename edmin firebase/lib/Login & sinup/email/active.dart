// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActiveUserPage extends StatefulWidget {
  final uids;
  const ActiveUserPage({super.key, this.uids});

  @override
  State<ActiveUserPage> createState() => _ActiveUserPageState();
}

class _ActiveUserPageState extends State<ActiveUserPage> {
  TextEditingController extensionController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active User Page'),
      ),
      body: Container(
        
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/aries_logo_auto_6_3_1.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              // Text fields for extension number, designation, and telephone number
              TextField(
                controller: extensionController,
                decoration: const InputDecoration(
                  labelText: 'Extension Number',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: designationController,
                decoration: const InputDecoration(
                  labelText: 'Designation',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Telephone Number',
                ),
              ),
              const SizedBox(height: 16),
              // Submit button
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(widget.uids)
                      .update({
                    'designation': designationController.text,
                    'extension': extensionController.text,
                    'telephone': telephoneController.text,
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              // Add more widgets or functionality as needed
            ],
          ),
        ),
      ),
    );
  }
}
