// ignore_for_file: camel_case_types, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profilePic extends StatefulWidget {
  const profilePic({super.key});

  @override
  State<profilePic> createState() => _profilePicState();
}

class _profilePicState extends State<profilePic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(),
      title: const Text("UPDATE YOUR PROFILE"),
        ),
      
      body: SafeArea(
        child:Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(children:  [
            CupertinoButton(onPressed: ()=>{}, child: 
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person,size:50)))
          ],
          ),
          ),
    )
    );
  }
}
