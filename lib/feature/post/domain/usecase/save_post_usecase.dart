import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';

class SavePostUseCase {
  final PostFirebaseRepo postFirebaseRepo;

  SavePostUseCase({required this.postFirebaseRepo});

  Stream<List<PostEntity>> call(PostEntity post) {
    return postFirebaseRepo.savePost(post);
  }
}