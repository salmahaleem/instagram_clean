import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class GetMyStoryUseCase {

  final StoryFirebaseRepo storyFirebaseRepo;

  const GetMyStoryUseCase({required this.storyFirebaseRepo});

  Stream<List<StoryEntity>> call(String uid) {
    return storyFirebaseRepo.getMyStory(uid);
  }
}