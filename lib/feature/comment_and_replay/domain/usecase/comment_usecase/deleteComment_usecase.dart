
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/repository/comment_firebase_repo.dart';

class DeleteCommentUseCase {
  final CommentFirebaseRepo commentFirebaseRepo;
  DeleteCommentUseCase({required this.commentFirebaseRepo});

  Future<void> call(CommentEntity comment) {
    return commentFirebaseRepo.deleteComment(comment);
  }
}