import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class SeenStoryUpdateUseCase {

  final StoryFirebaseRepo storyFirebaseRepo;

  const SeenStoryUpdateUseCase({required this.storyFirebaseRepo});

  Future<void> call(String storyId, int imageIndex, String userId) async {
    return await storyFirebaseRepo.seenStoryUpdate(storyId, imageIndex, userId);
  }
}