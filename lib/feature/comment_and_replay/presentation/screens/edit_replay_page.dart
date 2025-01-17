import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/widget/edit_replay_widget.dart';

class EditReplayPage extends StatelessWidget {
  final ReplayEntity replay;

  const EditReplayPage({Key? key, required this.replay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplayCubit>(
      create: (context) => di.getIt<ReplayCubit>(),
      child: EditReplayWidget(replay: replay),
    );
  }
}