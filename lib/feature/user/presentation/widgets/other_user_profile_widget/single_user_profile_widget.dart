import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramButton.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_other_single_user/get_other_single_user_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class SingleUserProfileWidget extends StatefulWidget {
  final String otherUserId;
  const SingleUserProfileWidget({Key? key, required this.otherUserId}) : super(key: key);

  @override
  State<SingleUserProfileWidget> createState() => _SingleUserProfileWidgetState();
}

class _SingleUserProfileWidgetState extends State<SingleUserProfileWidget> {
  String _currentUid = "";

  @override
  void initState() {
    BlocProvider.of<GetOtherSingleUserCubit>(context).getSingleOtherUser(otherUid: widget.otherUserId);
    BlocProvider.of<PostCubit>(context).getAllPosts(post: PostEntity());
    super.initState();

   di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOtherSingleUserCubit, GetOtherSingleUserState>(
      builder: (context, userState) {
        if (userState is GetOtherSingleUserLoaded) {
          final singleUser = userState.otherUser;
          return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading:GestureDetector(
                  onTap: () => context.go('/explorePage'),
                  child: Icon(Icons.arrow_back),
                ) ,
                title: Text("${singleUser.username}", style: Theme.of(context).textTheme.titleMedium),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: UserPhoto(imageUrl: singleUser.profileUrl,image: singleUser.imageFile),
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text("${singleUser.totalPosts}",),
                                  verticalSpace(8.h),
                                  Text('${LocaleKeys.profile_posts.tr()}')
                                ],
                              ),
                              horizontalSpace(25.w),
                              GestureDetector(
                                onTap: () {
                                  //Navigator.pushNamed(context, PageConst.followersPage, arguments: singleUser);

                                },
                                child: Column(
                                  children: [
                                    Text("${singleUser.totalFollowers}",),
                                    verticalSpace(8.h),
                                    Text('${LocaleKeys.profile_followers.tr()}')
                                  ],
                                ),
                              ),
                              horizontalSpace(25.w),
                              GestureDetector(
                                onTap: () {
                                  // Navigator.pushNamed(context, PageConst.followingPage, arguments: singleUser);
                                },
                                child: Column(
                                  children: [
                                    Text("${singleUser.totalFollowing}", ),
                                    verticalSpace(8.h),
                                    Text('${LocaleKeys.profile_following.tr()}' )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      verticalSpace(10.h),
                      Text("${singleUser.username}", style: Theme.of(context).textTheme.titleMedium),
                      verticalSpace(10.h),
                      Text("${singleUser.bio}", style: Theme.of(context).textTheme.titleSmall),
                      verticalSpace(10.h),
                      _currentUid == singleUser.uid ? Container() :InstagramButton(
                        text: singleUser.followers!.contains(_currentUid) ?"UnFollow":"Follow",
                        color: singleUser.followers!.contains(_currentUid) ? Colors.black26 : AppColors.buttonColor,
                        onPressed: () {
                      //     BlocProvider.of<ProfileCubit>(context).followUnFollowUser(
                      //     user: UserEntity(
                      //         uid: _currentUid,
                      //         otherUid: widget.otherUserId
                      //     )
                      // );
                          },
                      ),
                      verticalSpace(10.h),
                      BlocBuilder<PostCubit, PostState>(
                        builder: (context, postState) {
                          if (postState is PostLoaded) {
                            final posts = postState.posts.where((post) => post.creatorUid == widget.otherUserId).toList();
                            return GridView.builder(
                                itemCount: posts.length,
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.go('/postDetailsPage/:${posts[index].postId}');
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: UserPhoto(imageUrl: posts[index].postImageUrl),
                                    ),
                                  );
                                });

                          }
                          return Center(child: CircularProgressIndicator(),);
                        },
                      )
                    ],
                  ),
                ),
              )
          );

        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

}