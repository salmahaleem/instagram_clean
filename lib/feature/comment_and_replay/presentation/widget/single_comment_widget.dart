import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/widget/single_replay_widget.dart';
import 'package:instagram_clean/feature/post/presentation/screens/update_post_page.dart';

import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/generated/locale_keys.dart';
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserEntity? currentUser;

  const SingleCommentWidget(
      {Key? key,
        required this.comment,
        this.onLongPressListener,
        this.onLikeClickListener,
        this.currentUser})
      : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {

  String _currentUid = "";

  @override
  void initState() {
    di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });

    BlocProvider.of<ReplayCubit>(context).getReplays(replay: ReplayEntity(postId: widget.comment.postId, commentId: widget.comment.commentId));

    super.initState();
  }

  late bool _isUserReplaying = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.comment.creatorUid == _currentUid? widget.onLongPressListener : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: UserPhoto(imageUrl: widget.comment.userProfileUrl,image: widget.currentUser!.imageFile),
              ),
            ),
            horizontalSpace(10.w),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.comment.username}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        GestureDetector(
                            onTap: widget.onLikeClickListener,
                            child: Icon(
                              widget.comment.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: widget.comment.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : Colors.white10,
                            ))
                      ],
                    ),
                    verticalSpace(4.h),
                    Text(
                      "${widget.comment.description}",
                      style: TextStyle(color: Colors.white),
                    ),
                    verticalSpace(4.h),
                    Row(
                      children: [
                        Text(
                          "${DateFormat("dd/MMM/yyy").format(widget.comment.createAt!.toDate())}",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white10)
                        ),
                        horizontalSpace(15.w),
                        GestureDetector(
                            onTap: (){
                              setState(() {
                              _isUserReplaying = !_isUserReplaying;
                            });},
                            child: Text(
                              "${LocaleKeys.home_replay.tr()}",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white10)
                            )),
                        horizontalSpace(15.w),
                        GestureDetector(
                          onTap: () {
                            widget.comment.totalReplays == 0? print("no replays") :
                            BlocProvider.of<ReplayCubit>(context).getReplays(replay: ReplayEntity(postId: widget.comment.postId, commentId: widget.comment.commentId));
                          },
                          child: Text(
                            "${LocaleKeys.comment_view_replays.tr()}",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white10)
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ReplayCubit, ReplayState>(
                      builder: (context, replayState) {
                        if (replayState is ReplayLoaded) {
                          final replays = replayState.replays.where((element) => element.commentId == widget.comment.commentId).toList();
                          return ListView.builder(shrinkWrap: true, physics: ScrollPhysics(), itemCount: replays.length, itemBuilder: (context, index) {
                            return SingleReplayWidget(replay: replays[index],
                              onLongPressListener: () {
                                _openBottomModalSheet(context: context, replay: replays[index]);
                              },
                              onLikeClickListener: () {
                                _likeReplay(replay: replays[index]);
                              },
                            );

                          });

                        }
                        return Center(child: CircularProgressIndicator(),);
                      },
                    ),
                    _isUserReplaying == true ? verticalSpace(10.h) : verticalSpace(0.h),
                    _isUserReplaying == true
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InstagramTextField(
                            hintText: "${LocaleKeys.home_post_your_replay.tr()}",
                            controller: Constant.ReplayDescriptionController,
                            isObscureText: false,),
                        verticalSpace(10.h),
                        GestureDetector(
                          onTap: _createReplay,
                          child: Icon(Icons.send,color: AppColors.buttonColor,)
                        )
                      ],
                    )
                        : Container(
                      width: 0,
                      height: 0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createReplay() {
    BlocProvider.of<ReplayCubit>(context).createReplay(
        replay: ReplayEntity(
          replayId: Uuid().v1(),
          createAt: Timestamp.now(),
          likes: [],
          username: widget.currentUser!.username,
          userProfileUrl: widget.currentUser!.profileUrl,
          creatorUid: widget.currentUser!.uid,
          postId: widget.comment.postId,
          commentId: widget.comment.commentId,
          description: Constant.ReplayDescriptionController.text,
        ))
        .then((value) {
      setState(() {
        Constant.ReplayDescriptionController.clear();
        _isUserReplaying = false;
      });
    });
  }

  _openBottomModalSheet({required BuildContext context, required ReplayEntity replay}) {
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                   verticalSpace(8.h),
                    Divider(
                      thickness: 1,
                      color: Colors.black26,
                    ),
                    verticalSpace(8.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _deleteReplay(replay: replay);
                        },
                        child: Text(
                          "${LocaleKeys.comment_delete_replay.tr()}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                    verticalSpace(7.h),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    verticalSpace(7.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          context.go('/editReplayPage',extra: replay);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage(post: Constant.postEntity,)));
                        },
                        child: Text(
                          "${LocaleKeys.comment_update_replay.tr()}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                    verticalSpace(7.h),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _deleteReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).deleteReplay(replay: ReplayEntity(
        postId: replay.postId,
        commentId: replay.commentId,
        replayId: replay.replayId
    ));
  }

  _likeReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(replay: ReplayEntity(
        postId: replay.postId,
        commentId: replay.commentId,
        replayId: replay.replayId
    ));
  }

}