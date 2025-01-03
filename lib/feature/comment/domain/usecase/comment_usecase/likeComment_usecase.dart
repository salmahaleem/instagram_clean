import 'package:instagram_clean/feature/comment/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment/domain/repository/comment_firebase_repo.dart';

class LikeCommentUseCase {
  final CommentFirebaseRepo commentFirebaseRepo;
  LikeCommentUseCase({required this.commentFirebaseRepo});

  Future<void> call(CommentEntity comment) {
    return commentFirebaseRepo.likeComment(comment);
  }
}