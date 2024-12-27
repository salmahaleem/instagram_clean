import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';

class UpdatePostUseCase {
  final PostFirebaseRepo postFirebaseRepo;

  UpdatePostUseCase({required this.postFirebaseRepo});

  Future<void> call(PostEntity post) {
    return postFirebaseRepo.updatePost(post);
  }

}