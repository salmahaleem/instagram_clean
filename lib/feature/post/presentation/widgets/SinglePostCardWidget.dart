import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/screens/comment_page.dart';
import 'package:instagram_clean/feature/home/domain/entity/app_entity.dart';

import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/like_widget.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getSingleOtherUser_usecase.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  final UserEntity userEntity;

  const SinglePostCardWidget({Key? key, required this.post, required this.userEntity,}) : super(key: key);

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
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

  bool _isLikeAnimating = false;
  bool _isSaved = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //headPost(),

              GestureDetector(
                onTap: () {
                  //context.go('/profile',extra: Constant.userEntity);
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: UserPhoto(imageUrl:widget.post.userProfileUrl),
                      ),
                    ),
                    horizontalSpace(10.w),
                    Text("${widget.post.username}",
                        style: Theme.of(context).textTheme.titleSmall)
                  ],
                ),
              ),
              widget.post.creatorUid == _currentUid
                  ? GestureDetector(
                      onTap: () {
                        _openBottomModalSheet(context, widget.post);
                      },
                      child: Icon(
                        Icons.more_vert,
                      ))
                  : Container(
                      width: 0,
                      height: 0,
                    )
            ],
          ),
          verticalSpace(7.h),
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: UserPhoto(imageUrl: "${widget.post.postImageUrl}"),
                ),
                AnimatedOpacity(
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
              ],
            ),
          ),
          verticalSpace(7.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: _likePost,
                      child: Icon(
                        widget.post.likes!.contains(_currentUid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: widget.post.likes!.contains(_currentUid)
                            ? Colors.red
                            : Colors.white,
                      )),
                  horizontalSpace(5.w),
                  Text("${widget.post.totalLikes}",
                      style: Theme.of(context).textTheme.titleSmall),
                  horizontalSpace(10.w),
                  GestureDetector(
                      onTap: () {
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
                                  return CommentPage(appEntity: AppEntity(uid: _currentUid,postId: widget.post.postId)) ;
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Icon(FeatherIcons.messageCircle)),
                  horizontalSpace(5.w),
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
                                  return CommentPage(appEntity: AppEntity(uid: _currentUid,postId: widget.post.postId)) ;
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Text("${widget.post.totalComments}",
                          style: Theme.of(context).textTheme.titleSmall)),
                  horizontalSpace(10.w),
                  Icon(
                    FeatherIcons.send,
                  ),
                ],
              ),
              _isSaved == true?
              GestureDetector(
                onTap: _saved,
                child: Icon(
                       Icons.bookmark_outlined
                ))
                  :GestureDetector(
                  child: Icon(
                      Icons.bookmark_border_outlined
                  )
             ),
            ],
          ),
          verticalSpace(7.h),
          Row(
            children: [
              Text("${widget.post.username}",
                  style: Theme.of(context).textTheme.titleSmall),
              horizontalSpace(10.w),
              Text(
                "${widget.post.description}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          verticalSpace(7.h),
          Text("${DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate())}",style: Theme.of(context).textTheme.titleSmall, ),
        ],
      ),
    );
  }

  _openBottomModalSheet(BuildContext context, PostEntity post) {
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
                        "More Options",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: _deletePost,
                        child: Text("Delete Post",
                            style: Theme.of(context).textTheme.titleSmall),
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
                          context.go('/updatePostPage',extra: post);
                        },
                        child: Text(
                          "Update Post",
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


  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId));
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostEntity(postId: widget.post.postId));
  }

  _saved(){
    BlocProvider.of<PostCubit>(context).savedPosts(post: PostEntity(postId: widget.post.postId));
  }
}
