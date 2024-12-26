import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';

import '../../../domain/usecase/uploadImageToStorage_usecase.dart';


class SignupPhoto extends StatefulWidget{
  final UserEntity userEntity;

   SignupPhoto({super.key, required this.userEntity, });

  @override
  State<SignupPhoto> createState() => _SignupPhotoState();
}

class _SignupPhotoState extends State<SignupPhoto> {
  File? _image;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedFile != null){
         setState(() {
           _image = File(pickedFile.path);
           di.getIt<UploadImageToStorageUseCase>().call(_image!, false, "profileImages");
         });

        //   setState(() {
      //     _image = File(pickedFile.path);
      // });
      } else {
        print("no image has been selected");
      }

    } catch(e) {
      print("error selected image $e");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Failed to select image. Please try again."),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
  return  Stack(
    alignment: Alignment.bottomRight,
    children: [
      Container(
        width: 100,
        height: 100,
        child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: UserPhoto(imageUrl: widget.userEntity.profileUrl, image:_image),
        ),
        ),
      GestureDetector(
        onTap: selectImage,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    ],
  );
  }
}