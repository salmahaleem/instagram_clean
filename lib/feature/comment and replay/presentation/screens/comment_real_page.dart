import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/cubit/comment_cubit.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/widget/comment_real_widget.dart';
import 'package:instagram_clean/feature/home/domain/entity/app_entity.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/get_single_real/single_real_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';

class CommentRealPage extends StatelessWidget{
  final AppEntity appEntity;

  const CommentRealPage({super.key, required this.appEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentCubit>(
          create: (context) => di.getIt<CommentCubit>(),
        ),
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.getIt<GetSingleUserCubit>(),
        ),
        BlocProvider<SingleRealCubit>(
          create: (context) => di.getIt<SingleRealCubit>(),
        ),
      ],
      child: CommentRealWidget(appEntity: appEntity),
    );
  }

}