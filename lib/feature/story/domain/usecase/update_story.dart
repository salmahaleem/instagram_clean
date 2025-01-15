import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class UpdateStoryUseCase {

  final StoryFirebaseRepo storyFirebaseRepo;

  const UpdateStoryUseCase({required this.storyFirebaseRepo});

  Future<void> call(StoryEntity story) async {
    return await storyFirebaseRepo.updateStory(story);
  }
}