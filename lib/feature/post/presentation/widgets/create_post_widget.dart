import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/profile_textfield.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/upload_post_widget.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/uploadImageToStorage_usecase.dart';
import 'package:instagram_clean/generated/locale_keys.dart';
import 'package:uuid/uuid.dart';

class CreatePostWidget extends StatefulWidget {
  final UserEntity currentUser;
  const CreatePostWidget({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {

  bool _uploading = false;



  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          Constant.selectedImage = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });

    } catch(e) {
      print("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Constant.selectedImage == null? UploadPostWidget(userEntity: widget.currentUser,) : Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(onTap: () => setState(() => Constant.selectedImage = null),child: Icon(Icons.close, size: 28,)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(onTap: _submitPost,child: Icon(Icons.arrow_forward)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              child: ClipRRect(borderRadius: BorderRadius.circular(40),child: UserPhoto(imageUrl: widget.currentUser.profileUrl,image: Constant.profileImage)),
            ),
            verticalSpace(10.h),
            Text("${widget.currentUser.username}", style: Theme.of(context).textTheme.titleMedium),
            verticalSpace(10.h),
            Container(
              width: double.infinity,
              height: 200,
              child: UserPhoto(image: Constant.selectedImage),
            ),
            verticalSpace(10),
            ProfileTextField(hintText: "${LocaleKeys.home_description.tr()}", controller: Constant.descriptionController, isObscureText: false,),
            verticalSpace(10),
            _uploading == true?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator()
              ],
            ) : Container(width: 0, height: 0,)
          ],
        ),
      ),
    );
  }

  _submitPost() {
    setState(() {
      _uploading = true;
    });
    di.getIt<UploadImageToStorageUseCase>().call(Constant.selectedImage!, true, "posts").then((imageUrl) {
      _createSubmitPost(image: imageUrl,currentUser:widget.currentUser);
      context.go('/mainPage/:${widget.currentUser.uid}');
    });
  }

  _createSubmitPost({required String image, required UserEntity currentUser}) {
    BlocProvider.of<PostCubit>(context).createPost(
        post: PostEntity(
            description: Constant.descriptionController.text,
            createAt: Timestamp.now(),
            creatorUid: currentUser.uid,
            likes: [],
            postId: Uuid().v1(),
            postImageUrl: image,
            totalComments: 0,
            totalLikes: 0,
            username: currentUser.username,
            userProfileUrl: currentUser.profileUrl
        )
    ).then((value) => _clear());
  }

  _clear() {
    setState(() {
      _uploading = false;
      Constant.descriptionController.clear();
      Constant.selectedImage = null;
    });
  }

}