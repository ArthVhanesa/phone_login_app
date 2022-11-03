import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_login_app/screens/login_screen.dart';
import 'package:phone_login_app/screens/profile_screen.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var OTP = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Container(
            height: 370,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Enter the OTP you received",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                // OTP input field
                Pinput(
                  length: 6,
                  showCursor: true,
                  // onCompleted: (pin) => print(pin),
                  onChanged: (value) => {OTP = value},
                ),
                submitButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox submitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color(0xFFd5715b),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          onPressed: () async {
            try {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: LogInScreen.verifyID, smsCode: OTP);

              // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential);
              Get.off(() =>
                  ProfileScreen()); //Go to the profile screen after OTP verifiation
            } catch (e) {
              Get.snackbar('Wrong OTP', 'Please enter correct OTP');
            }
          },
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 18),
          )),
    );
  }
}
