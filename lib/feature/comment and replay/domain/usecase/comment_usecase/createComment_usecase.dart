
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/comment_firebase_repo.dart';

import '../../entity/comment_entity.dart';

class CreateCommentUseCase {
  final CommentFirebaseRepo commentFirebaseRepo;

  CreateCommentUseCase({required this.commentFirebaseRepo});

  Future<void> call(CommentEntity comment) {
    return commentFirebaseRepo.createComment(comment);
  }
}