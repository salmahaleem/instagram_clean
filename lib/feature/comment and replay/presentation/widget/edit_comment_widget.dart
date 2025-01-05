import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/instagramButton.dart';
import 'package:instagram_clean/core/widgets/instagramTextField.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/cubit/comment_cubit.dart';

import '../../domain/entity/comment_entity.dart';

class EditCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  const EditCommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  State<EditCommentWidget> createState() => _EditCommentWidgetState();
}

class _EditCommentWidgetState extends State<EditCommentWidget> {

  TextEditingController? _descriptionController;

  bool _isCommentUpdating = false;

  @override
  void initState() {
    _descriptionController = TextEditingController(text: widget.comment.description);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Edit Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            InstagramTextField(
              controller: _descriptionController,
              hintText: "description",
              isObscureText: false,
            ),
            verticalSpace(10.h),
            InstagramButton(
              text: "Save Changes",
              onPressed: () {
              _editComment();
            },
            ),
            verticalSpace(10.h),
            _isCommentUpdating == true?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Updating...", style: TextStyle(color: Colors.white),),
                horizontalSpace(10.w),
                CircularProgressIndicator(),
              ],
            ) : Container(width: 0, height: 0,)
          ],
        ),
      ),
    );
  }

  _editComment() {
    setState(() {
      _isCommentUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context).updateComment(comment: CommentEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
        description: _descriptionController!.text
    )).then((value) {
      setState(() {
        _isCommentUpdating = false;
        _descriptionController!.clear();
      });
      context.go('/mainPage');
    });
  }
}