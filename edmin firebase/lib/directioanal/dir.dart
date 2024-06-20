// ignore_for_file: unused_local_variable, use_build_context_synchronously, camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use, non_constant_identifier_names

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmin/calender/calender.dart';
import 'package:edmin/chat/homePage.dart';
import 'package:edmin/contact/contact.dart';
import 'package:edmin/directioanal/makeAdmin/makeadminpage.dart';
import 'package:edmin/directioanal/profile.dart';
import 'package:edmin/orders/forms/forms.dart';
import 'package:edmin/orders/govt/notice.dart';
import 'package:edmin/help/searchPage.dart';
import 'package:edmin/orders/notice/notice.dart';
import 'package:edmin/orders/nps/nps.dart';
import 'package:edmin/orders/offical/officalOrder.dart';
import 'package:edmin/orders/payslip/payslips.dart';
import 'package:edmin/orders/payslip/upload.dart';
import 'package:edmin/to%20do/todo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edmin/Login%20&%20sinup/phone/model.dart';
import 'package:edmin/Login%20&%20sinup/email/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:amplify_flutter/amplify.dart';
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';


// var uidd = FirebaseAuth.instance.currentUser?.uid.toString();

class dir extends StatefulWidget {
  const dir({Key? key});

  @override
  State<dir> createState() => _dir();
}

class _dir extends State<dir> {
  late UserModel userModel;
  bool isAdminn = false;
  late Future<String> userStatusFuture;

  Future<String> fetchUserStatus() async {
    var authResult = await Amplify.Auth.fetchAuthSession();
var uidd = authResult.isSignedIn ? authResult.userSub : null;
    var userUid = uidd;
    var snapshot = await FirebaseFirestore.instance.collection('user').doc(userUid).get();
    var userStatus = snapshot.get('status');

    checkAdmin().then((result) {
      setState(() {
        isAdminn = result;
      });
    });
    if (userStatus == 'ret') {
      return 'ret';
    } else {
      if (isAdminn) {
        userStatus = 'ret';
        return 'ret';
      }
    }
    return userStatus;
  }

  Future<bool> checkAdmin() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('user').doc(uidd).get();
      isAdminn = userDoc['admin'];
      if (isAdminn == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const login_screen()));
  }

  void pp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void makeAdmin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MAKEADMINsearchPage()));
  }

  @override
  void initState() {
    super.initState();

    checkAdmin().then((result) {
      setState(() {
        isAdminn = result;
      });
    });

    userStatusFuture = fetchUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80, // Set the toolbar height to a smaller value
        title: Row(
          children: [
            const Text('MENU', style: TextStyle(color: Color.fromARGB(255, 174, 174, 174))),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset("assets/aries_logo_auto_6_3_1.png", width: 65, height: 100),
            ),
          ],
        ),
        actions: [
          if (isAdminn)
            ElevatedButton(
              onPressed: makeAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 152, 57, 50),
              ),
              child: const Text('Make Admin'),
            ),
          IconButton(onPressed: pp, icon: const Icon(Icons.person, color: Color.fromARGB(255, 136, 77, 72))),
          IconButton(onPressed: logout, icon: const Icon(Icons.exit_to_app, color: Color.fromARGB(255, 142, 67, 62))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 3, bottom: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Row 1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align icons to start, space between, and end
              children: [
                
                buildButton('CALENDAR', FontAwesomeIcons.calendar, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EventCalendarScreen()));
                }),
                buildButton('CHAT', FontAwesomeIcons.comment, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homePage()));
                }),
              ],
            ),
            // Row 2
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildButton('CONTACT', FontAwesomeIcons.solidAddressCard, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactList()));
                }),
                buildButton('ERP', FontAwesomeIcons.globe, () {
                  final url = Uri.parse('http://erp.aries.res.in:7073/web/login');
                  launchUrl(url, mode: LaunchMode.externalApplication);
                }),
                buildButton('FORMS', FontAwesomeIcons.forward, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Forms()));
                }),
              ],
            ),
            // Row 3
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildButton('GOVT ORDER', FontAwesomeIcons.solidFileAlt, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GovtNotice()));
                }),
                buildButton('HELP DESK', FontAwesomeIcons.question, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => searchPage()));
                }),
                buildButton('NPS UPDATE', FontAwesomeIcons.sync, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const npsUpdate()));
                }),
              ],
            ),
            // Row 4
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildButton('NOTICE', FontAwesomeIcons.solidBell, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Notice()));
                }),
                buildButton('OFFICE ORDERS', FontAwesomeIcons.solidFile, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OfficialOrder()));
                }),
                buildButton('TO/DO', FontAwesomeIcons.check, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                }),
              ],
            ),
            // Row 5
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<String>(
                  future: userStatusFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == "ret") {
                        return buildButton('PAY SLIP', FontAwesomeIcons.moneyBill, () {
                          if (isAdminn) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const uploadPay()));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PaySlips()));
                          }
                        });
                      }
                    }
                    return Container(); // or another placeholder widget
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String label, IconData iconData, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10), // Add horizontal padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              iconData,
              size: 40.0,
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            Text(
              label,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
    );
  }
}
