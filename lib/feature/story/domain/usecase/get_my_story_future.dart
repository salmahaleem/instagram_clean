import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class GetMyStoryFutureUseCase {

  final StoryFirebaseRepo storyFirebaseRepo;

  GetMyStoryFutureUseCase({required this.storyFirebaseRepo});

  Future<List<StoryEntity>> call(String uid) async {
    return storyFirebaseRepo.getMyStoryFuture(uid);
  }
}