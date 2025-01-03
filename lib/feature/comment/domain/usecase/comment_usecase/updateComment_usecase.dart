import 'package:instagram_clean/feature/comment/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment/domain/repository/comment_firebase_repo.dart';

class UpdateCommentUseCase {
  final CommentFirebaseRepo commentFirebaseRepo;
  UpdateCommentUseCase({required this.commentFirebaseRepo});

  Future<void> call(CommentEntity comment) {
    return commentFirebaseRepo.updateComment(comment);
  }
}