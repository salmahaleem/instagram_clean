import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/comment/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment/presentation/cubit/comment_cubit.dart';
import 'package:instagram_clean/feature/comment/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_clean/feature/comment/presentation/widget/single_comment_widget.dart';
import 'package:instagram_clean/feature/home/domain/entity/app_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:uuid/uuid.dart';

class CommentWidget extends StatefulWidget{
  final AppEntity appEntity;

  const CommentWidget({super.key, required this.appEntity});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.appEntity.uid!);

    BlocProvider.of<SinglePostCubit>(context).getSinglePost(postId: widget.appEntity.postId!);

    BlocProvider.of<CommentCubit>(context).getComments(postId: widget.appEntity.postId!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Comments"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, singleUserState) {
          if (singleUserState is GetSingleUserLoaded) {
            final singleUser = singleUserState.user;
            return BlocBuilder<SinglePostCubit, SinglePostState>(
              builder: (context, singlePostState) {
                if (singlePostState is SinglePostLoaded) {
                  final singlePost = singlePostState.post;
                  return BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: UserPhoto(imageUrl: singlePost.userProfileUrl),
                                        ),
                                      ),
                                     horizontalSpace(10.w),
                                      Text(
                                        "${singlePost.username}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  verticalSpace(7.h),
                                  Text(
                                    "${singlePost.description}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace(7.h),
                            Divider(
                              color: Colors.grey,
                            ),
                            verticalSpace(7.h),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: commentState.comments.length,
                                  itemBuilder: (context, index) {
                                    final singleComment = commentState.comments[index];
                                    return BlocProvider(
                                      create: (context) => di.getIt<ReplayCubit>(),
                                      child: SingleCommentWidget(
                                        currentUser: singleUser,
                                        comment: singleComment,
                                        onLongPressListener: () {
                                          _openBottomModalSheet(
                                            context: context,
                                            comment: commentState.comments[index],
                                          );
                                        },
                                        onLikeClickListener: () {
                                          _likeComment(comment: commentState.comments[index]);
                                        },
                                      ),
                                    );
                                  }),
                            ),
                            _commentSection(currentUser: singleUser)
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: UserPhoto(imageUrl: currentUser.profileUrl),
              ),
            ),
            horizontalSpace(10.w),
            Expanded(
                child: TextFormField(
                  controller: Constant.CommentDescriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Post your comment...",
                      hintStyle: TextStyle(color: Colors.grey)),
                )),
            GestureDetector(
                onTap: () {
                  _createComment(currentUser);
                },
                child: Text(
                  "Post",
                  style: TextStyle(fontSize: 15, color: AppColors.buttonColor),
                ))
          ],
        ),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
        comment: CommentEntity(
          totalReplays: 0,
          commentId: Uuid().v1(),
          createAt: Timestamp.now(),
          likes: [],
          username: currentUser.username,
          userProfileUrl: currentUser.profileUrl,
          description: Constant.CommentDescriptionController.text,
          creatorUid: currentUser.uid,
          postId: widget.appEntity.postId,
        ))
        .then((value) {
      setState(() {
        Constant.CommentDescriptionController.clear();
      });
    });
  }

  _openBottomModalSheet({required BuildContext context, required CommentEntity comment}) {
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 1,
                      color:Colors.grey,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _deleteComment(commentId: comment.commentId!, postId: comment.postId!);
                        },
                        child: Text(
                          "Delete Comment",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
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
                          // Navigator.pushNamed(context, PageConst.updateCommentPage,
                          //     arguments: comment);

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));
                        },
                        child: Text(
                          "Update Comment",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
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

  _deleteComment({required String commentId, required String postId}) {
    BlocProvider.of<CommentCubit>(context)
        .deleteComment(comment: CommentEntity(commentId: commentId, postId: postId));
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context)
        .likeComment(comment: CommentEntity(commentId: comment.commentId, postId: comment.postId));
  }
  }
