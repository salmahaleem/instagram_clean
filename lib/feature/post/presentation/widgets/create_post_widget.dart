import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/profile_textfield.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/uploadImageToStorage_usecase.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class CreatePostWidget extends StatefulWidget {
  final UserEntity? userEntity;
  CreatePostWidget({Key? key, this.userEntity})
      : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  String _currentUid = "";

  @override
  void initState() {
    di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }
  bool _uploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureDetector(
              onTap: () {
                context.go('/mainPage');
                setState(() => Constant.selectedImage = null);
              },
              child: Icon(
                Icons.close,
                size: 28,
              )),
          title: Text(
            '${LocaleKeys.home_new_post.tr()}',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: _submitPost,
                  child: Icon(
                    Icons.arrow_forward,
                    color:  _uploading ? Colors.grey : Colors.blue,
                  )),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: _uploading ? Center(child: CircularProgressIndicator(),)
                   :Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          child: UserPhoto(image: Constant.selectedImage),
                        ),
                        verticalSpace(10.h),
                        ProfileTextField(
                          hintText: "${LocaleKeys.home_description}",
                          controller: Constant.descriptionController,
                          isObscureText: false,
                        ),
                        _uploading == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Uploading...",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  CircularProgressIndicator()
                                ],
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              )
                      ],
                    ),
                  )
          ),
        )
    );
  }

  _submitPost() {
    setState(() {
      _uploading = true;
    });
    di.getIt<UploadImageToStorageUseCase>().call(Constant.selectedImage!, true, "posts").then((imageUrl) {
      _createSubmitPost(image: imageUrl);
    }).then((_){
      context.go('/postDetailsPage/:${Constant.postId}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created'),backgroundColor: Colors.greenAccent,),
      );
    }).catchError((error) {
      setState(() {
        _uploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit post: $error')),
      );
    });
  }


  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context).createPost(
        post: PostEntity(
            description: Constant.descriptionController.text,
            createAt: Timestamp.now(),
            creatorUid: widget.userEntity!.uid,
            likes: [],
            saved: [],
            postId: Constant.postId,
            postImageUrl: image,
            totalComments: 0,
            totalLikes: 0,
            totalSaved: 0,
            username: widget.userEntity!.username,
            userProfileUrl: widget.userEntity!.profileUrl
        )
    ).then((value) => _clear());
    print("created post >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  }

  _clear() {
    setState(() {
      _uploading = false;
      Constant.descriptionController.clear();
      Constant.selectedImage = null;
    });
  }
}
