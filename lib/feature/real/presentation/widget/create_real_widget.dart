import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/real_cubit.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/generated/locale_keys.dart';
import 'package:video_player/video_player.dart';

import '../../../user/domain/usecase/uploadImageToStorage_usecase.dart';

class CreateRealWidget extends StatefulWidget {
  final UserEntity currentUser;
  File videoFile;
  CreateRealWidget(this.videoFile, {super.key, required this.currentUser});

  @override
  State<CreateRealWidget> createState() => _CreateRealWidgetState();
}

class _CreateRealWidgetState extends State<CreateRealWidget> {

  String _currentUid = "";

  late VideoPlayerController controller;
  bool _uploading = false;
  @override
  void initState() {
    super.initState();
    di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '${LocaleKeys.home_new_reals.tr()}',
          style: Theme.of(context).textTheme.titleMedium
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: _uploading
            ? const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ))
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Container(
                    width: 150.w,
                    height: 380.h,
                    child: controller.value.isInitialized
                        ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    )
                        : const CircularProgressIndicator()),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 60,
                width: 280.w,
                child: TextField(
                  controller: Constant.caption,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: '${LocaleKeys.home_description.tr()}',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: _submitReal,
                child: Container(
                  alignment: Alignment.center,
                  height: 45.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '${LocaleKeys.home_share.tr()}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitReal() {
    setState(() {
      _uploading = true;
    });
    di.getIt<UploadImageToStorageUseCase>().call(widget.videoFile, true, "reals").then((realUrl) {
      _createSubmitReal(real: realUrl,currentUser:widget.currentUser);
    }).then((_){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Real created'),backgroundColor: Colors.greenAccent,),
      );
      context.go('/mainPage/:${widget.currentUser.uid}');
    }).catchError((error) {
      setState(() {
        _uploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit real: $error')),
      );
    });
  }


  _createSubmitReal({required String real,required UserEntity currentUser}) {
    BlocProvider.of<RealCubit>(context).createReal(
        real: RealEntity(
            description: Constant.caption.text,
            createAt: Timestamp.now(),
            creatorUid: currentUser.uid,
            likes: [],
            realId: Constant.realId,
            realUrl: real,
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
      Constant.caption.clear();
      controller.closedCaptionFile;
    });
  }
}