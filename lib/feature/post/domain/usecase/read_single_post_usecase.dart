import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';

class ReadSinglePostUseCase {
  final PostFirebaseRepo postFirebaseRepo;

  ReadSinglePostUseCase({required this.postFirebaseRepo});

  Stream<List<PostEntity>> call(String postId) {
    return postFirebaseRepo.readSinglePost(postId);
  }
}