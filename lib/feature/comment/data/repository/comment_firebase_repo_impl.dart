import 'package:instagram_clean/feature/comment/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment/domain/repository/comment_firebase_repo.dart';

class CommentFirebaseRepoImpl implements CommentFirebaseRepo{
   final CommentFirebaseRepo commentFirebaseRepo;

  CommentFirebaseRepoImpl({ required this.commentFirebaseRepo});
  @override
  Future<void> createComment(CommentEntity comment) async => commentFirebaseRepo.createComment(comment);

  @override
  Future<void> deleteComment(CommentEntity comment) async => commentFirebaseRepo.deleteComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment) async => commentFirebaseRepo.likeComment(comment);

  @override
  Stream<List<CommentEntity>> readComments(String postId) => commentFirebaseRepo.readComments(postId);

  @override
  Future<void> updateComment(CommentEntity comment) async => commentFirebaseRepo.updateComment(comment);

}