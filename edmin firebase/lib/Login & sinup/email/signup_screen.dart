// signup_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:edmin/Login%20&%20sinup/email/active.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'active.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  bool isActive = true;
  bool admin = false;

  File? imageFile;
  bool isSigningIn = false;

  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void createAccount() async {
    setState(() {
      isSigningIn = true;
    });
String firstName=firstNameController.text.trim().toUpperCase();
String lastName=lastNameController.text.trim().toUpperCase();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();
    String division = divisionController.text.trim();
    String name = "$firstName ${lastName.toUpperCase()}";
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        division.isEmpty ||
        imageFile == null) {
      showErrorMessage(context, "Please enter all details");
      setState(() {
        isSigningIn = false;
      });
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String uid = userCredential.user!.uid;

        FirebaseFirestore firestore = FirebaseFirestore.instance;

        String imagePath = "profile_images/$uid.jpg";
        Reference storageReference =
            FirebaseStorage.instance.ref().child(imagePath);
        await storageReference.putFile(imageFile!);
        String imageUrl = await storageReference.getDownloadURL();

        Map<String, dynamic> newUserData = {
          "uid": uid,
          "first name":firstName,
          "last name":lastName,
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "division": division,
          "profilePic": imageUrl,
          "status": isActive ? "active" : "ret",
          "admin": admin
        };

        await firestore.collection("user").doc(uid).set(newUserData);
        if (isActive) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActiveUserPage(uids: uid),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        String errorName = e.code.toString();
        showErrorMessage(context, errorName);
      } finally {
        setState(() {
          isSigningIn = false;
        });
      }
    }
  }

  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("UPLOAD PROFILE PICTURE"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  selectImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.photo_album),
                title: const Text("SELECT FROM GALLERY"),
              ),
              ListTile(
                onTap: () {
                  selectImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("SELECT FROM CAMERA"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
     
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 70),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showPhotoOption();
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            child: imageFile != null
                                ? Image.file(
                                    imageFile!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 50.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Click icon to upload image",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 47, 51, 131),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "First Name",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                          ), Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Last Name",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: " Phone number",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: divisionController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Division",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: true,
                                groupValue: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = value as bool;
                                  });
                                },
                              ),
                              const Text('Active'),
                              Radio(
                                value: false,
                                groupValue: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = value as bool;
                                  });
                                },
                              ),
                              const Text('Retired'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            isActive ? createAccount() : createAccount();
                          },
                          child: isSigningIn
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : isActive
                                  ? const Text('Next')
                                  : const Text('Sign Up'),
                        ),
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
