import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/all_posts_single_user.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/post.dart';
import 'package:instagram_clean/generated/assets.dart';

class HomePage extends StatelessWidget {
  final UserEntity userEntity;
  const HomePage({Key? key, required this.userEntity}) : super(key: key);

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
            child: Icon(FeatherIcons.messageCircle),
          )
        ],
      ),
      body: BlocProvider<PostCubit>(
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
                    child: SinglePostCardWidget(post: post,),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
),
    );
  }

  _noPostsYetWidget() {
    return Center(child: Text("No Posts Yet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),);
  }
}