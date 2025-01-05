import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/comment_entity.dart';


abstract class CommentFirebaseRepo{
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

}