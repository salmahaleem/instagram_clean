import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class CreateStoryUseCase {

  final StoryFirebaseRepo storyFirebaseRepo;

  CreateStoryUseCase({required this.storyFirebaseRepo});

  Future<void> call(StoryEntity story) async {
    return await storyFirebaseRepo.createStory(story);
  }
}