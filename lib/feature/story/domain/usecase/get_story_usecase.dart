import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class GetStoryUseCase {

  final StoryFirebaseRepo storyFirebaseRepo;

  const GetStoryUseCase({required this.storyFirebaseRepo});

  Stream<List<StoryEntity>> call(StoryEntity story) {
    return storyFirebaseRepo.getStory(story);
  }
}