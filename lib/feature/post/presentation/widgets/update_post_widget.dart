import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/user/domain/usecase/uploadImageToStorage_usecase.dart';

class UpdatePostWidget extends StatefulWidget {
  final PostEntity post;
  const UpdatePostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePostWidget> createState() => _UpdatePostWidgetState();
}

class _UpdatePostWidgetState extends State<UpdatePostWidget> {

  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController = TextEditingController(text: widget.post.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  File? _image;
  bool? _uploading = false;
  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Edit Post"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(onTap: _updatePost,child: Icon(Icons.done, color: AppColors.buttonColor, size: 28,)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: UserPhoto(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              verticalSpace(10.h),
              Text("${widget.post.username}", style: Theme.of(context).textTheme.titleMedium,),
              verticalSpace(10.h),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: UserPhoto(
                        imageUrl: widget.post.postImageUrl,
                        image: _image
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Icon(Icons.edit, color: AppColors.buttonColor,),
                      ),
                    ),
                  )
                ],
              ),
              verticalSpace(10.h),
              InstagramTextField(
                controller: _descriptionController,
                hintText: "Description",
                isObscureText: false,
              ),
              verticalSpace(10.h),
              _uploading == true?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Updating...", style: TextStyle(color: Colors.white),),
                  horizontalSpace(10.w),
                  CircularProgressIndicator()
                ],
              ) : Container(width: 0, height: 0,)
            ],
          ),
        ),
      ),
    );
  }

  _updatePost() {
    setState(() {
      _uploading = true;
    });
    if (_image == null) {
      _submitUpdatePost(image: widget.post.postImageUrl!);
    } else {
     di.getIt<UploadImageToStorageUseCase>().call(_image!, true, "posts").then((imageUrl) {
        _submitUpdatePost(image: imageUrl);
      });
    }
  }


  _submitUpdatePost({required String image}) {
    BlocProvider.of<PostCubit>(context).updatePost(
        post: PostEntity(
            creatorUid: widget.post.creatorUid,
            postId: widget.post.postId,
            postImageUrl: image,
            description: _descriptionController!.text
        )
    ).then((value) => _clear());
  }

  _clear() {
    setState(() {
      _descriptionController!.clear();
      Navigator.pop(context);
      _uploading = false;
    });
  }

}