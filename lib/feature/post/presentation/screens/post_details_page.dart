import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:intl/intl.dart';

import '../../../user/domain/usecase/getCurrentUserId_usecase.dart';
class PostDetailMainWidget extends StatefulWidget {
  final String postId;

  const PostDetailMainWidget({super.key, required this.postId});
  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {

  String _currentUid = "";

  @override
  void initState() {

    BlocProvider.of<SinglePostCubit>(context).getSinglePost(postId: widget.postId);
    di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Post Detail"),
        leading: GestureDetector(onTap: () {
          context.go('/mainPage');
          setState(() => Constant.selectedImage = null);},child: Icon(Icons.arrow_back, size: 28,)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<SinglePostCubit, SinglePostState>(
        builder: (context, getSinglePostState) {
          if (getSinglePostState is SinglePostLoaded) {
            final singlePost = getSinglePostState.post;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: UserPhoto(imageUrl: "${Constant.userEntity.profileUrl}"),
                            ),
                          ),
                          verticalSpace(10.h),
                          Text(
                            "${Constant.userEntity.username}",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                       singlePost.creatorUid == _currentUid ?
                       GestureDetector(
                          onTap: () => _openBottomModalSheet(context, singlePost),
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          )) : Container(width: 2, height: 2,color: Colors.red,)
                    ],
                  ),
                  verticalSpace(10.h),
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
                          child: UserPhoto(imageUrl: "${singlePost.postImageUrl}"),
                        ),
                        // AnimatedOpacity(
                        //   duration: Duration(milliseconds: 200),
                        //   opacity: _isLikeAnimating ? 1 : 0,
                        //   child: LikeAnimationWidget(
                        //       duration: Duration(milliseconds: 200),
                        //       isLikeAnimating: _isLikeAnimating,
                        //       onLikeFinish: () {
                        //         setState(() {
                        //           _isLikeAnimating = false;
                        //         });
                        //       },
                        //       child: Icon(
                        //         Icons.favorite,
                        //         size: 100,
                        //         color: Colors.white,
                        //       )),
                        // ),
                      ],
                    ),
                  ),
                  verticalSpace(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                                  onTap: _likePost,
                                  child: Icon(
                                    singlePost.likes!.contains(_currentUid)
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: singlePost.likes!.contains(_currentUid)
                                        ? Colors.red
                                        : Colors.white,
                                  )),
                          Text(
                                "   ${singlePost.totalLikes}",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                          horizontalSpace(10.w),
                          GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, PageConst.commentPage,
                                //     arguments:
                                //     AppEntity(uid: _currentUid, postId: singlePost.postId));
                                // //Navigator.push(context, MaterialPageRoute(builder: (context) => CommentPage()));
                              },
                              child: Icon(
                                FeatherIcons.messageCircle,
                                color: Colors.white,
                              )),
                          horizontalSpace(4.h),
                          GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, PageConst.commentPage,
                                //     arguments: AppEntity(uid: _currentUid, postId: singlePost.postId));
                              },
                              child: Text(
                                " ${singlePost.totalComments}",
                                style: TextStyle(color: Colors.white),
                              )),
                          horizontalSpace(10.h),
                          Icon(
                            FeatherIcons.send,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      horizontalSpace(40.h),
                      Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                      )
                    ],
                  ),
                  verticalSpace(10.h),
                  Row(
                    children: [
                      Text(
                        "${singlePost.username}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      verticalSpace(10.h),
                      Text(
                        "${singlePost.description}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  verticalSpace(10.h),
                  Text(
                    "${DateFormat("dd/MMM/yyy").format(singlePost.createAt!.toDate())}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );

          }
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }



  _openBottomModalSheet(BuildContext context, PostEntity post) {
    return showModalBottomSheet(context: context, builder: (context) {
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: _deletePost,
                    child: Text(
                      "Delete Post",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                verticalSpace(10.h),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                verticalSpace(10.h),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, PageConst.updatePostPage, arguments: post);
                      //
                      // // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));

                    },
                    child: Text(
                      "Update Post",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                verticalSpace(10.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(post: PostEntity(postId: widget.postId));
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(post: PostEntity(
        postId: widget.postId
    ));
  }
}