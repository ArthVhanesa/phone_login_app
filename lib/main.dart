// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phone_login_app/controllers/internet_status_controller.dart';
import 'package:phone_login_app/screens/home_screen.dart';
import 'package:phone_login_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('showHome') ?? false;

  await Firebase.initializeApp();
  runApp(MyApp(isLoggedIn: isLoggedIn, prefs: prefs));
}

class MyApp extends StatelessWidget {
  final _ = Get.put(InternetController());
  final bool isLoggedIn;
  final SharedPreferences prefs;

  MyApp({
    Key? key,
    required this.isLoggedIn,
    required this.prefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone LogIn App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const HomeScreen() : const LogInScreen(),
    );
  }
}
