import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class StoryFirebaseRepoImpl implements StoryFirebaseRepo{
  final StoryFirebaseRepo storyFirebaseRepo;

  StoryFirebaseRepoImpl({required this.storyFirebaseRepo});

  @override
  Future<void> createStory(StoryEntity story) async => storyFirebaseRepo.createStory(story);

  @override
  Future<void> deleteStory(StoryEntity story) async => storyFirebaseRepo.deleteStory(story);

  @override
  Stream<List<StoryEntity>> getMyStory(String uid) => storyFirebaseRepo.getMyStory(uid);

  @override
  Future<List<StoryEntity>> getMyStoryFuture(String uid) async => storyFirebaseRepo.getMyStoryFuture(uid);

  @override
  Stream<List<StoryEntity>> getStory(StoryEntity story)  => storyFirebaseRepo.getStory(story);

  @override
  Future<void> seenStoryUpdate(String storyId, int imageIndex, String userId) async => storyFirebaseRepo.seenStoryUpdate(storyId, imageIndex, userId);

  @override
  Future<void> updateOnlyImageStory(StoryEntity story) async => storyFirebaseRepo.updateOnlyImageStory(story);

  @override
  Future<void> updateStory(StoryEntity story) async => storyFirebaseRepo.updateStory(story);

}