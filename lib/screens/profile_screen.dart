import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  DateTime date = DateTime.now();
  File? image;
  String imgUrl = '';
  String gender = '';

  sendData() async {
    var storageImg = FirebaseStorage.instance.ref().child(image!.path);
    var task = storageImg.putFile(image!);
    final snapshot = await task.whenComplete(() => {});
    imgUrl = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection("users").add({
      'name': nameController.text,
      'img': imgUrl,
      'gender': gender,
      'dob': date
    });
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() => this.image = File(image.path));
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick an Image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15))),
                      builder: (context) => modalBottomSheet(),
                    )
                  },
                  child: image != null
                      ? CircleAvatar(
                          radius: 70,
                          foregroundImage: FileImage(image!),
                        )
                      : const CircleAvatar(
                          radius: 70,
                          foregroundImage: AssetImage('assets/profile.webp'),
                        ),
                ),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(width: 10),
                      Expanded(
                          child: TextField(
                        controller: nameController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(1969, 1, 1),
                        lastDate: date,
                      );
                      if (newDate == null) return;
                      setState(() {
                        date = newDate;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: 10),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                          ),
                        )
                      ],
                    ),
                  ),
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
            // sendData();
          },
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 18),
          )),
    );
  }

  Container modalBottomSheet() {
    return Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          imagePickerOption(
              'Camera', ImageSource.camera, Icons.photo_camera_outlined),
          imagePickerOption(
              'Gallery', ImageSource.gallery, Icons.image_outlined),
        ],
      ),
    );
  }

  InkWell imagePickerOption(String name, ImageSource source, IconData icon) {
    return InkWell(
      onTap: () => getImage(source),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 10),
            Text(
              name,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
