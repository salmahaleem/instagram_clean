
import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/like_widget.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class PostDetailsPage extends StatefulWidget{
  final String postId;
  //final UserEntity userEntity;
  PostDetailsPage({super.key, required this.postId, });


  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {

  String _currentUid = '';

  @override
  void initState() {
    super.initState();

    // Fetch the post
    BlocProvider.of<SinglePostCubit>(context).getSinglePost(postId: Constant.postId);
    // Get the current user ID
    di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      print("Current UID: $value");
      if (mounted) {
        setState(() {
          _currentUid = value;
        });
      }
    });
  }

  bool _isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(onPressed: () {
          context.go('/mainPage');
        },
        icon: Icon(Icons.arrow_back)),
        title: Text("Post Detail"),
        actions: [
          TextButton(
              onPressed: (){
                  context.go('/mainPage');
              }, child:Text("${LocaleKeys.profile_done.tr()}",style: Theme.of(context).textTheme
            .titleMedium!.copyWith(color: AppColors.buttonColor),),
          )
        ],
      ),
      body: BlocBuilder<SinglePostCubit,SinglePostState>(
          builder: (context,singlePostState){
            if(singlePostState is SinglePostLoaded){
              final singlePost = singlePostState.post;
              return Padding(
                padding: const EdgeInsets.all(8.0),
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
                            child: UserPhoto(imageUrl:singlePost.userProfileUrl),
                          ),
                        ),
                         verticalSpace(5.h),
                         Text(
                            "${singlePost.username}",
                            style: Theme.of(context).textTheme.titleMedium
                          ),
                      ],),
                        singlePost.creatorUid == _currentUid
                            ? GestureDetector(
                            onTap: ()=> _openBottomModalSheet(context, singlePost),
                            child: Icon(
                              Icons.more_vert,
                            ))
                            : Container(
                          width: 2,
                          height: 2,
                          color: Colors.red,
                        )

                    ],),
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
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: UserPhoto(imageUrl: singlePost.postImageUrl ?? 'default_image_url'),
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
                      ]
                    ),
                  ),
                    verticalSpace(10.h),
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
                        horizontalSpace(2.w),
                        Text(
                          "${singlePost.totalLikes}",
                          style: Theme.of(context).textTheme.titleSmall
                        ),
                        horizontalSpace(5.w),
                        GestureDetector(
                            onTap: () {

                            },
                            child: Icon(
                              FeatherIcons.messageCircle,
                            )),
                        horizontalSpace(2.w),
                        Text(
                    "${singlePost.totalComments}",
                    style: Theme.of(context).textTheme.titleSmall
                  ),
                        horizontalSpace(5.w),
                        GestureDetector(
                          child: Icon(
                            FeatherIcons.send,
                          ),
                        ),
                        horizontalSpace(210.w),
                        GestureDetector(
                          child: Icon(
                            Icons.bookmark_border,
                          ),
                        )
                      ],
                    ),
                    verticalSpace(10.h),
                    Row(
                      children: [
                        Text(
                          "${singlePost.username}",
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                        horizontalSpace(5.w),
                        Text(
                          "${singlePost.description}",
                          style: Theme.of(context).textTheme.titleSmall
                        ),
                      ],
                    ),
                  ],
                ),
              );

            }else if(singlePostState is SinglePostFailure){
                return Center(child: Text("error in get post ...... "));
            }
            return Center(child: Text("error in get post "));
          }),
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
                    style: Theme.of(context).textTheme.titleSmall
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
                    child: Text(
                      "Delete Post",
                      style: Theme.of(context).textTheme.titleSmall
                    ),
                  ),
                ),

                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                verticalSpace(3.h),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, PageConst.updatePostPage, arguments: post);
                    },
                    child: Text(
                      "Update Post",
                      style: Theme.of(context).textTheme.titleSmall
                    ),
                  ),
                ),
                verticalSpace(3.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(post: PostEntity(postId: Constant.postId));
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context).likePost(post: PostEntity(
        postId: Constant.postId
    ));
  }

}
