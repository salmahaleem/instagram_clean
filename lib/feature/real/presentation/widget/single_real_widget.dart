import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/screens/comment_real_page.dart';
import 'package:instagram_clean/feature/home/domain/entity/app_entity.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/like_widget.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/real_cubit.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/generated/locale_keys.dart';
import 'package:video_player/video_player.dart';

class SingleRealWidget extends StatefulWidget{
  final RealEntity real;

  const SingleRealWidget({super.key, required this.real});
  @override
  State<SingleRealWidget> createState() => _SingleRealWidgetState();
}

class _SingleRealWidgetState extends State<SingleRealWidget> {
  late VideoPlayerController controller;
  String _currentUid = "";

  @override
  void initState() {
    super.initState();
   di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
   controller = VideoPlayerController.network("${widget.real.realUrl}")..initialize().then((value) {
       setState(() {
         controller.setLooping(true);
         controller.setVolume(1);
         controller.play();
       });
     });

  }

  bool _isLikeAnimating = false;
  bool _isPlay = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        GestureDetector(
          onDoubleTap: () {
            _likeReal;
            setState(() {
              _isLikeAnimating = true;
            });
          },
          onTap: () {
            setState(() {
              _isPlay = !_isPlay;
            });
            if (_isPlay) {
              controller.play();
            } else {
              controller.pause();
            }
          },
          child: Container(
            width: double.infinity,
            height: 812.h,
            child: VideoPlayer(controller),
          ),
        ),
        if (!_isPlay)
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.white30,
              radius: 35.r,
              child: Icon(
                Icons.play_arrow,
                size: 35.w,
                color: Colors.white,
              ),
            ),
          ),
        Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _isLikeAnimating ? 1 : 0,
            child: LikeAnimationWidget(
                duration: Duration(milliseconds: 200),
                isLikeAnimating: _isLikeAnimating,
                onLikeFinish: () {
                  setState(() {
                    _isLikeAnimating = false;
                  });
                },
                child: Icon(
                  Icons.favorite,
                  size: 100,
                  color: Colors.white,
                )),
          ),
        ),
        Positioned(
          top: 430.h,
          right: 15.w,
          child: Column(
            children: [
              GestureDetector(
                  onTap: _likeReal,
                  child: Icon(
                    widget.real.likes!.contains(_currentUid)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: widget.real.likes!.contains(_currentUid)
                        ? Colors.red
                        : Colors.white,
                  )),
              verticalSpace(10.h),
              Text("${widget.real.totalLikes}",
                  style: Theme.of(context).textTheme.titleSmall),
              verticalSpace(10.h),
              GestureDetector(
                  onTap: () =>
                    showBottomSheet(
                      backgroundColor: Colors.transparent,
                      showDragHandle: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: DraggableScrollableSheet(
                            maxChildSize: 1.0,
                            initialChildSize: 1.0,
                            minChildSize: 0.2,
                            builder: (context, scrollController) {
                              return CommentRealPage(appEntity: AppEntity(uid: _currentUid,realId: widget.real.realId)) ;
                            },
                          ),
                        );
                      },
                    ),
                  child: Icon(FeatherIcons.messageCircle)),
              verticalSpace(5.h),
              GestureDetector(
                  onTap: () {
                    showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: DraggableScrollableSheet(
                            maxChildSize: 1.0,
                            initialChildSize: 1.0,
                            minChildSize: 0.2,
                            builder: (context, scrollController) {
                              return CommentRealPage(appEntity: AppEntity(uid: _currentUid,realId: widget.real.realId)) ;
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Text("${widget.real.totalComments}",
                      style: Theme.of(context).textTheme.titleSmall)),
              verticalSpace(5.h),
              Icon(
                Icons.send,
                color: Colors.white,
                size: 28.w,
              ),
              verticalSpace(5.h),
              widget.real.creatorUid == _currentUid
                  ? GestureDetector(
                  onTap: ()=>_openBottomModalSheet(context, widget.real),
                  child: Icon(
                    Icons.more_vert,
                  ))
                  : Container(
                width: 0,
                height: 0,
              )
            ],
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: 10.w,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: 35.h,
                      width: 35.w,
                      child: UserPhoto(imageUrl: widget.real.userProfileUrl,),
                    ),
                  ),
                  horizontalSpace(5.w),
                  Text(
                    "${widget.real.username}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  horizontalSpace(10.w),
                ],
              ),
             verticalSpace(5.h),
              Text("${widget.real.description}",
                style: Theme.of(context).textTheme.titleMedium
              ),
            ],
          ),
        )
      ],
    );

  }

  _openBottomModalSheet(BuildContext context,RealEntity real) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: Colors.black.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "${LocaleKeys.comment_more_options.tr()}",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                   verticalSpace(8.h),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    verticalSpace(8.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: _deleteReal,
                        child: Text("${LocaleKeys.post_delete_real.tr()}",
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  _likeReal() {
    BlocProvider.of<RealCubit>(context)
        .likeReal(real: RealEntity(realId: widget.real.realId));
  }

  _deleteReal() {
    BlocProvider.of<RealCubit>(context)
        .deleteReal(real: RealEntity(realId: widget.real.realId));
  }
}