// ignore_for_file: camel_case_types, avoid_print, use_build_context_synchronously, unused_catch_clause

import 'package:animate_do/animate_do.dart';
import 'package:edmin/directioanal/dir.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class verifyOtp extends StatefulWidget {
  final String verificationId;
  const verifyOtp({super.key, required this.verificationId});

  @override
  State<verifyOtp> createState() => _verifyOtpState();
}

class _verifyOtpState extends State<verifyOtp> {
  TextEditingController otpControler = TextEditingController();
  void verifyOtp() async {
    String otp = otpControler.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const dir()));
      }
    } on FirebaseAuthException catch (e) {
      // String error = e.code.toString();
      //printerror);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('OTP VERIFICATION'),
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
                                    // border: Border(bottom: BorderSide(color:  Color.fromRGBO(143, 148, 251, 1)))
                                    ),
                                child: TextField(
                                  controller: otpControler,
                                  maxLength: 6,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: "Enter Otp",
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
                              verifyOtp();
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
