import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';

abstract class PostFirebaseRepo{

  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
  Future<void> savePost(PostEntity post);

}