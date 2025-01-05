

import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/comment_firebase_repo.dart';

class ReadCommentsUseCase {
  final CommentFirebaseRepo commentFirebaseRepo;

  ReadCommentsUseCase({required this.commentFirebaseRepo});

  Stream<List<CommentEntity>> call(String postId) {
    return commentFirebaseRepo.readComments(postId);
  }
}