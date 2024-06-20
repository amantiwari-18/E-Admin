
// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print, unused_local_variable

import 'package:edmin/Login%20&%20sinup/phone/verify_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';



class home_screen extends StatefulWidget {
  const home_screen({super.key});
  @override
  State<home_screen> createState() => _home_screen();
}

class _home_screen extends State<home_screen> {
  TextEditingController phoneController = TextEditingController();

  void sendOtp() async {
    String phone = "+91${phoneController.text.trim()}";
   
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, ResendingToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => verifyOtp(
                        verificationId: verificationId,
                      )));
        },
   
        verificationCompleted: (Credential) {},
        verificationFailed: (e) {
          String error = e.code.toString();
          //printerror);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 120));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Login using Phone Number'),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 300),
                child: Column(
                  children: //this is for the whole box that flot up
                      <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(143, 148, 251, 1)),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              //this is the one about email       #2nd box ie. box in box
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                    
                                    ),
                                child: TextField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Phone Number",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                ),
                              ),
                            ],
                          ),
                        )),
                    // here is the css for the flot up box
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1900),
                        child: SizedBox(
                          height: 50,
                          child: Center(
                              child: ElevatedButton(
                            onPressed: () {
                              sendOtp();
                            },
                            child: const Text('LOGIN'),
                          )),
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
