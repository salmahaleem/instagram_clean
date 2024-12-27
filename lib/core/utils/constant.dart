import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';

class Constant {

  //firebase constant
  static const String users ="users";
  static const String comment ="comment";
  static const String posts ="posts";
  static const String replay ="replay";

  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController phone = TextEditingController();
  static TextEditingController username = TextEditingController();
  static TextEditingController gender = TextEditingController();
  static TextEditingController website = TextEditingController();
  static TextEditingController bio = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();

  static  bool isPassVis = true;
  static GlobalKey <FormState> reformKey = GlobalKey <FormState> ();
  static GlobalKey <FormState> formKey = GlobalKey <FormState> ();

  static UserEntity userEntity = UserEntity();

  // static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  //static File? image;




}