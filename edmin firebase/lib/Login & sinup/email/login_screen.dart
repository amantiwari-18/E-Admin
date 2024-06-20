// ignore_for_file: camel_case_types, avoid_print, use_build_context_synchronously, unused_local_variable, use_key_in_widget_constructors

import 'package:edmin/Login%20&%20sinup/email/signup_screen.dart';
import 'package:edmin/directioanal/dir.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key});
  @override
  State<login_screen> createState() => _login_screen();
}

class _login_screen extends State<login_screen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      showErrorMessage(context, "Please enter the empty fields");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const dir()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMsg = e.code.toString();
        showErrorMessage(context, errorMsg);
      }
    }
  }

  void sendPasswordResetEmail() async {
    String email = emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showErrorMessage(context, "Email sent");
      } on FirebaseAuthException catch (e) {
        String errorMsg = e.code.toString();
        showErrorMessage(context, errorMsg);
      }
    } else {
      showErrorMessage(context, "Please enter the email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 150,
            ),
            Container(
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/aries_logo_auto_6_3_1.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 236, 236, 236),
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
                                color: Color.fromRGBO(172, 172, 175, 1),
                              ),
                            ),
                          ),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email ",
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: const Text('LOGIN'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      sendPasswordResetEmail();
                    },
                    child: const Text('Forget Password'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("DON'T HAVE AN ACCOUNT?"),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        icon: const Icon(Icons.install_mobile_outlined),
                        label: const Text("SIGNUP"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
