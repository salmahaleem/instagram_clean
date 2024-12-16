import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clean/generated/assets.dart';
import 'dart:io';



class SignupPhoto extends StatelessWidget{
  final String? image;
  final ValueChanged<String> onImagePicked;

  const SignupPhoto({
    super.key,
    this.image,
    required this.onImagePicked,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: buildImageProvider(),
            backgroundColor: Colors.grey,
          ),
          GestureDetector(
            onTap: () => showImageSourceDialog(context),
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
      ),
    );
  }
  void showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => pickImage(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => pickImage(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      onImagePicked(pickedFile.path);
    }
    Navigator.of(context).pop();
  }

  ImageProvider buildImageProvider() {
    if (image != null) {
      return const AssetImage(Assets.imagesProfileimage);
      // return image!.startsWith('http')
      //     ? NetworkImage(image!)
      //     : FileImage(File(image!));
    } else {
      return const AssetImage(Assets.imagesProfileimage);
    }
  }
}