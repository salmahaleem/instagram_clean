import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';

class PostFirebaseRepoImpl implements PostFirebaseRepo{
  final PostFirebaseRepo postFirebaseRepo;

  PostFirebaseRepoImpl({required this.postFirebaseRepo});
  
  @override
  Future<void> createPost(PostEntity post) async => postFirebaseRepo.createPost(post);

  @override
  Future<void> deletePost(PostEntity post) async => postFirebaseRepo.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) async => postFirebaseRepo.likePost(post);

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) => postFirebaseRepo.readPosts(post);

  @override
  Future<void> updatePost(PostEntity post) async => postFirebaseRepo.updatePost(post);

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) => postFirebaseRepo.readSinglePost(postId);

  @override
  Stream<List<PostEntity>> savePost(PostEntity post) => postFirebaseRepo.savePost(post);

}