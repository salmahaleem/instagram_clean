import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/screens/post_details_page.dart';

class PostDetails extends StatelessWidget{
final String postId;

  const PostDetails({super.key, required this.postId});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<SinglePostCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<PostCubit>(),
        ),
      ],
      child: PostDetailMainWidget(postId: postId,),
    );
  }

}