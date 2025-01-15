import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';

abstract class StoryFirebaseRepo {

  Future<void> createStory(StoryEntity story);
  Future<void> updateStory(StoryEntity story);
  Future<void> updateOnlyImageStory(StoryEntity story);
  Future<void> seenStoryUpdate(String storyId, int imageIndex, String userId);
  Future<void> deleteStory(StoryEntity story);
  Stream<List<StoryEntity>> getStory(StoryEntity story);
  Stream<List<StoryEntity>> getMyStory(String uid);
  Future<List<StoryEntity>> getMyStoryFuture(String uid);

}