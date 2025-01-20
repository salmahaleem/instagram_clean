import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/chats_page.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/story/presentation/screens/story_page.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/SinglePostCardWidget.dart';
import 'package:instagram_clean/generated/assets.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class HomePage extends StatelessWidget {
  final UserEntity currentUser;
  final PostEntity? postEntity;
  const HomePage({Key? key, required this.currentUser, this.postEntity}) : super(key: key);

  Widget checkTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      return Image.asset(Assets.imagesLightLogo);
    } else {
      return Image.asset(Assets.imagesInstagramLogo);
    }
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: SizedBox(
            height: 50.h,
            width: 100.w,
            child: checkTheme(context)
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){},
                    child: Icon(Icons.favorite_border_outlined)),
                horizontalSpace(10.w),
                GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(uid: "${currentUser.uid}")));},
                    child: Icon(FeatherIcons.messageCircle)),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: 120.h,
                width: double.infinity,
                child: StoryPage(currentUser: currentUser)),
            verticalSpace(5.h),
            Expanded(child:
            BlocProvider<PostCubit>(
                 create: (context) => di.getIt<PostCubit>()..getAllPosts(post:  PostEntity()),
                child: BlocBuilder<PostCubit, PostState>(
                builder: (context, postState) {
                  if (postState is PostLoading) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if (postState is PostFailure) {
                    print("Some Failure occured while creating the post");
                  }
                  if (postState is PostLoaded) {
                    return postState.posts.isEmpty? _noPostsYetWidget() : ListView.builder(
                      itemCount: postState.posts.length,
                      itemBuilder: (context, index) {
                        final post = postState.posts[index];
                        return BlocProvider(
                          create: (context) => di.getIt<PostCubit>(),
                          child: SinglePostCardWidget(post: post,userEntity: currentUser,),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
                },
              ),
            ),
      )
          ],
        ),
      ),
    );
  }

  _noPostsYetWidget() {
    return Center(child: Text("${LocaleKeys.home_no_posts_yet.tr()}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),);
  }
}