import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';

class ReadPostsUseCase {
  final PostFirebaseRepo postFirebaseRepo;

  ReadPostsUseCase({required this.postFirebaseRepo});

  Stream<List<PostEntity>> call(PostEntity post) {
    return postFirebaseRepo.readPosts(post);
  }
}