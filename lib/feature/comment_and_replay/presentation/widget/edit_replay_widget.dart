import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramButton.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/cubit/replay/replay_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class EditReplayWidget extends StatefulWidget {
  final ReplayEntity replay;
  const EditReplayWidget({Key? key, required this.replay}) : super(key: key);

  @override
  State<EditReplayWidget> createState() => _EditReplayWidgetState();
}

class _EditReplayWidgetState extends State<EditReplayWidget> {

  TextEditingController? _descriptionController;

  bool _isReplayUpdating = false;

  @override
  void initState() {
    _descriptionController = TextEditingController(text: widget.replay.description);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("${LocaleKeys.comment_edit_replay.tr()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            InstagramTextField(
              controller: _descriptionController,
              hintText: "${LocaleKeys.home_description.tr()}",
              isObscureText: false,
            ),
            verticalSpace(10.h),
            InstagramButton(
              text: "${LocaleKeys.comment_save_changes.tr()}",
              onPressed: () {
                _editReplay();
              },
            ),
            verticalSpace(10.h),
            _isReplayUpdating == true?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ) : Container(width: 0, height: 0,)
          ],
        ),
      ),
    );
  }

  _editReplay() {
    setState(() {
      _isReplayUpdating = true;
    });
    BlocProvider.of<ReplayCubit>(context).updateReplay(replay: ReplayEntity(
        postId: widget.replay.postId,
        commentId: widget.replay.commentId,
        replayId: widget.replay.replayId,
        description: _descriptionController!.text
    )).then((value) {
      setState(() {
        _isReplayUpdating = false;
        _descriptionController!.clear();
      });
      context.go('/mainPage');
    });
  }
}