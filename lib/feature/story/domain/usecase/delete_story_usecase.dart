import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class DeleteStoryUseCase {

  final StoryFirebaseRepo storyFirebaseRepo;

   DeleteStoryUseCase({required this.storyFirebaseRepo});

  Future<void> call(StoryEntity story) async {
    return await storyFirebaseRepo.deleteStory(story);
  }
}