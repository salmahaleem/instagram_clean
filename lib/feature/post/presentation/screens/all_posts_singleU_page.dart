import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/all_posts_single_user.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_other_single_user/get_other_single_user_cubit.dart';

class AllPostsSingleUPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetOtherSingleUserCubit>(
          create: (context) => di.getIt<GetOtherSingleUserCubit>()..getSingleOtherUser(otherUid: Constant.otherUserId),
        ),
        BlocProvider<PostCubit>(
          create: (context) => di.getIt<PostCubit>()..getAllPosts(post: PostEntity()),
        ),
      ],
      child: AllPostsSingleUser(),
    );
  }

}