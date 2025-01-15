import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:uuid/uuid.dart';

class Constant {

  //firebase constant
  static const String users ="users";
  static const String comment ="comment";
  static const String posts ="posts";
  static const String reals ="reals";
  static const String replay ="replay";
  static const String myChat ="myChat";
  static const String messages ="messages";
  static const String story ="story";

  static TextEditingController email = TextEditingController();
  static TextEditingController password = TextEditingController();
  static TextEditingController phone = TextEditingController();
  static TextEditingController username = TextEditingController();
  static TextEditingController gender = TextEditingController();
  static TextEditingController website = TextEditingController();
  static TextEditingController bio = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController CommentDescriptionController = TextEditingController();
  static TextEditingController ReplayDescriptionController = TextEditingController();
  static TextEditingController caption = TextEditingController();
  static TextEditingController textMessageController = TextEditingController();
  static ScrollController scrollController  = ScrollController();

  static  bool isPassVis = true;

  static UserEntity userEntity = UserEntity();

  static File? selectedImage;
  static String postId = Uuid().v1();
  static String realId = Uuid().v1();
  static String otherUserId = " ";
  static PostEntity postEntity = PostEntity();
  static File? profileImage;
  static String? profileUrl = " ";

}

class MessageTypeConst {

  static const String textMessage = "textMessage";
  static const String fileMessage = "fileMessage";
  static const String emojiMessage = "emojiMessage";
  static const String photoMessage = "photoMessage";
  static const String audioMessage = "audioMessage";
  static const String videoMessage = "videoMessage";
  static const String gifMessage = "gifMessage";


  static Future<String> uploadMessageFile(
      {required File file, Function(bool isUploading)? onComplete, String? uid, String? otherUid,String? type}) async {
    onComplete!(true);

    final ref = FirebaseStorage.instance.ref().child(
        "message/$type/$uid/$otherUid/${DateTime.now().millisecondsSinceEpoch}");

    final uploadTask = ref.putData(await file.readAsBytes(),  SettableMetadata(contentType: 'image/png'),);

    final imageUrl =
    (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    onComplete(false);
    return await imageUrl;
  }

}