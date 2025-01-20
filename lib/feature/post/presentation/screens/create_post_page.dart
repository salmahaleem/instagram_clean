import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/create_post_widget.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';

class CreatePostPage extends StatelessWidget {
  final UserEntity currentUser;

  const CreatePostPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => di.getIt<PostCubit>(),
      child: CreatePostWidget(currentUser: currentUser),
    );
  }
}