import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/post_details_page.dart';

class PostDetail extends StatelessWidget {
  final String postId;

  const PostDetail({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SinglePostCubit>(
          create: (context) => di.getIt<SinglePostCubit>(),
        ),
        BlocProvider<PostCubit>(
          create: (context) => di.getIt<PostCubit>(),
        ),
      ],
      child: PostDetailsPage(postId: postId),
    );
  }
}