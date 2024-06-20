// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController extentionController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  late UserModel userProfile;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('user').doc(user.uid).get();

      if (userData.exists) {
        Map<String, dynamic>? userMap =
            userData.data() as Map<String, dynamic>?;

        if (userMap != null) {
          setState(() {
            userProfile = UserModel.fromMap(userMap);

            nameController.text = userProfile.name ?? "";
            emailController.text = userProfile.email ?? "";
            phoneController.text = userProfile.phone ?? "";
            designationController.text = userProfile.designation ?? "";
            divisionController.text = userProfile.division ?? "";
            extentionController.text = userProfile.extention ?? "";
            telephoneController.text = userProfile.telephone ?? "";
          });
        }
      }
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? imageUrl = userProfile.profilePic;

      if (_image != null) {
        // Upload the new image
        TaskSnapshot taskSnapshot = await FirebaseStorage.instance
            .ref('profile_pics/${user.uid}')
            .putFile(_image!);

        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'designation': designationController.text,
        'division': divisionController.text,
        'extention': extentionController.text,
        'telephone': telephoneController.text,
        'profilePic': imageUrl,
      });

      // Reload the updated profile
      loadUserProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: const CircleAvatar(
                  radius: 60,
                  
                      // ? FileImage(_image!)
                      // : userProfile.profilePic != null
                          // ? NetworkImage(userProfile.profilePic!)
                          // : const AssetImage('assets/default_avatar.png'),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField("Name", nameController),
              _buildTextField("Email", emailController),
              _buildTextField("Phone", phoneController),
              _buildTextField("Designation", designationController),
              _buildTextField("Division", divisionController),
              _buildTextField("Extension", extentionController),
              _buildTextField("Telephone", telephoneController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          TextField(controller: controller),
        ],
      ),
    );
  }
}
