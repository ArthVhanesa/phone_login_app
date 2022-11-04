import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_login_app/controllers/internet_status_controller.dart';
import 'package:phone_login_app/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _ = Get.put(InternetController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Phone LogIn App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LogInScreen());
  }
}
