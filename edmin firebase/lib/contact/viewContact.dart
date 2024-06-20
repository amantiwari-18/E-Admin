// ignore_for_file: use_build_context_synchronously, camel_case_types, file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class viewContact extends StatefulWidget {
  final SrchUID;
  const viewContact({super.key, required this.SrchUID});

  @override
  State<viewContact> createState() => _viewContactState();
}

class _viewContactState extends State<viewContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController extentionController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  late UserModel userProfile;


  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData =

          await FirebaseFirestore.instance.collection('user').doc(widget.SrchUID).get();

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
        

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(

         child: Image.asset(
           "assets/aries_logo_auto_6_3_1.png", // Replace with your image asset path
            fit: BoxFit.cover,
           
        ) 
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
