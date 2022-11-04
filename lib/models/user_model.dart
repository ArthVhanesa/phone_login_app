// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? name;
  DateTime? dob;
  String? img;
  String? gender;

  User({
    this.name,
    this.dob,
    this.img,
    this.gender,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        dob: (json['dob'] as Timestamp).toDate(),
        img: json['img'],
        gender: json['gender'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'dob': dob,
        'img': img,
        'gender': gender,
      };
}
