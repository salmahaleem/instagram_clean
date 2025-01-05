import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';

import '../widgets/explore_widget/explore_widget.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostCubit>(
          create: (context) => di.getIt<PostCubit>(),
        ),
      ],
      child: SearchMainWidget(),
    );
  }
}