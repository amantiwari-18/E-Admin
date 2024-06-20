// ignore_for_file: camel_case_types, non_constant_identifier_names, use_key_in_widget_constructors, use_super_parameters

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:edmin/directioanal/dir.dart';
import 'package:edmin/firebase_options.dart';
import 'package:edmin/Login%20&%20sinup/email/login_screen.dart';
import 'package:edmin/notification/noti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

var uuid = const Uuid();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  await _initializeFirebase();
  await _initializeDownloader();
  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class ck extends StatelessWidget {
  const ck({Key? key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return const dir();
    }

    return const login_screen();
  }
}

  Future<void> _initializeDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(debug: true);
  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(5, 255, 255, 255),
      ),
      home: const ck(),
    );
  }
}
