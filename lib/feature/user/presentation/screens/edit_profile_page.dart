import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/uploadImageToStorage_usecase.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/edit_profile_widgets/main_info.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/edit_profile_widgets/private_info.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity userEntity;

  EditProfilePage({super.key, required this.userEntity});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isUpdating = false;
  File? _image;
  //function show dialog
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
                onTap: () => selectImage(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => selectImage(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  //function select profile image
  Future selectImage(BuildContext context,ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if(pickedFile != null){
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print("no image has been selected");
      }

    } catch(e) {
      print("error selected image $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to select image. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  void _updateUserProfileData() {
    setState(() => _isUpdating = true);
    if (_image == null) {
      _updateUserProfile(" ");
    } else {
      di.getIt<UploadImageToStorageUseCase>().call(_image!, false, "profileImages")
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      }).catchError((e) {
        print("Error uploading image: $e");

      });
    }
  }

  //function update without image
  Future<void> _updateUserProfile(String profileUrl) async {
    try {
       await BlocProvider.of<ProfileCubit>(context).updateUser(
           user: UserEntity(
        uid: widget.userEntity.uid,
        username: Constant.username.text,
        bio: Constant.bio.text,
        website: Constant.website.text,
        email: Constant.email.text,
        phone: Constant.phone.text,
        gender: Constant.gender.text,
        totalFollowers: 0 ,
        totalFollowing: 0 ,
        totalPosts: 0,
        profileUrl: profileUrl,
          ));
    } catch (e) {
      // Show error feedback (handled by BlocConsumer listener)
      print("Error updating profile: $e");
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () => context.go('/mainPage',extra: Constant.userEntity),
              child: Icon(Icons.cancel_outlined)),
          title: Center(
              child: Text(
            '${LocaleKeys.profile_editProfile.tr()}',
            style: TextStyle(fontSize: 15.sp),
          )),
          actions: [
            BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Updated Successfully!"),
                      backgroundColor: Color(0xFFA5D6A7),
                    ),
                  );
                  context.go('/mainPage',extra: Constant.userEntity);
                } else if (state is ProfileFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Color(0xFFEF5350),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return GestureDetector(
                  onTap: (){
                    _updateUserProfileData;
                    context.go('/mainPage',extra: Constant.userEntity);
                  },
                  child: Icon(
                    Icons.done,
                    color: _isUpdating ? Colors.white : AppColors.buttonColor,
                    size: 32,
                  ),
                );
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:SingleChildScrollView(
              child: Column(
                children: [
              Column(
              children: [
              Center(
              child: Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: UserPhoto(imageUrl: widget.userEntity.profileUrl, image: _image),
                ),
              ),
        ),
        verticalSpace(15.h),
        Center(
          child: GestureDetector(
            onTap: () =>  showImageSourceDialog(context),
            child: Text(
              "${LocaleKeys.profile_change_profile_photo.tr()}",
              style: TextStyle(color: AppColors.buttonColor, fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        ],
      ),
                  verticalSpace(25.h),
                  MainInfo(),
                  verticalSpace(40.h),
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        '${LocaleKeys.profile_private_information.tr()}',
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                  verticalSpace(20.h),
                  PrivateInfo()
                ],
              ),
            )
        ),

    );
  }
}
