import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';

class DeletePostUseCase {
  final PostFirebaseRepo postFirebaseRepo;

  DeletePostUseCase({required this.postFirebaseRepo});

  Future<void> call(PostEntity post) {
    return postFirebaseRepo.deletePost(post);
  }
}