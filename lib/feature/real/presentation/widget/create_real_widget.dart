import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:video_player/video_player.dart';

import '../../../user/domain/usecase/uploadImageToStorage_usecase.dart';

class CreateRealWidget extends StatefulWidget {
  final UserEntity userEntity;
  File videoFile;
  CreateRealWidget(this.videoFile, {super.key, required this.userEntity});

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
          'New Reels',
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
                  decoration: const InputDecoration(
                    hintText: 'Write a caption ...',
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
                    'Share',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     // Container(
              //     //   alignment: Alignment.center,
              //     //   height: 45.h,
              //     //   width: 150.w,
              //     //   decoration: BoxDecoration(
              //     //     color: Colors.white,
              //     //     border: Border.all(
              //     //       color: Colors.black,
              //     //     ),
              //     //     borderRadius: BorderRadius.circular(10.r),
              //     //   ),
              //     //   child: Text(
              //     //     'Save draft',
              //     //     style: TextStyle(fontSize: 16.sp),
              //     //   ),
              //     // ),
              //
              //   ],
              // )
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
      _createSubmitReal(real: realUrl);
    }).then((_){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Real created'),backgroundColor: Colors.greenAccent,),
      );
      context.go('/mainPage');
    }).catchError((error) {
      setState(() {
        _uploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit real: $error')),
      );
    });
  }


  _createSubmitReal({required String real}) {
    BlocProvider.of<RealCubit>(context).createReal(
        real: RealEntity(
            description: Constant.caption.text,
            createAt: Timestamp.now(),
            creatorUid: widget.userEntity.uid,
            likes: [],
            realId: Constant.realId,
            realUrl: real,
            totalComments: 0,
            totalLikes: 0,
            username: widget.userEntity.username,
            userProfileUrl: widget.userEntity.profileUrl
        )
    ).then((value) => _clear());
    print("created real >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  }

  _clear() {
    setState(() {
      _uploading = false;
      Constant.caption.clear();
      controller.closedCaptionFile;
    });
  }
}