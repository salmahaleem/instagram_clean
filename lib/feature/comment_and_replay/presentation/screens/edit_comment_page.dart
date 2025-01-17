import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/cubit/comment_cubit.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/widget/edit_comment_widget.dart';


class EditCommentPage extends StatelessWidget {
  final CommentEntity comment;

  const EditCommentPage({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>(
      create: (context) => di.getIt<CommentCubit>(),
      child: EditCommentWidget(comment: comment),
    );
  }
}