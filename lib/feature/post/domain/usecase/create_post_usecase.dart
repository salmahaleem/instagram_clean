import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';

import '../entitys/post_entity.dart';

class CreatePostUseCase {
  final PostFirebaseRepo postFirebaseRepo;
  CreatePostUseCase({required this.postFirebaseRepo});

  Future<void> call(PostEntity post) {
    return postFirebaseRepo.createPost(post);
  }

}