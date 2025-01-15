
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/story/data/model/story_model.dart';
import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';

class StoryRemoteDataSourceImpl implements StoryFirebaseRepo{
  final FirebaseFirestore firebaseFirestore;

  StoryRemoteDataSourceImpl({required this.firebaseFirestore});


  @override
  Future<void> createStory(StoryEntity story) async{
    final storyCollection =
    firebaseFirestore.collection(Constant.story);

    final storyId = storyCollection.doc().id;

    final newStatus = StoryModel(
      imageUrl: story.imageUrl,
      profileUrl: story.profileUrl,
      uid: story.uid,
      createdAt: story.createdAt,
      username: story.username,
      storyId: storyId,
      description: story.description,
      stories: story.stories,
    ).toDocument();

    final storyDocRef = await storyCollection.doc(storyId).get();

    try {
      if (!storyDocRef.exists) {
        storyCollection.doc(storyId).set(newStatus);
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while creating status");
    }
  }

  @override
  Future<void> deleteStory(StoryEntity story) async{
    final storyCollection =
    firebaseFirestore.collection(Constant.story);

    try {
      storyCollection.doc(story.storyId).delete();
    } catch (e) {
      print("some error occur while deleting status");
    }
  }

  @override
  Stream<List<StoryEntity>> getMyStory(String uid) {
    final storyCollection =
    firebaseFirestore.collection(Constant.story)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));


    return storyCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StoryModel.fromSnapshot(e))
        .toList());
  }

  @override
  Future<List<StoryEntity>> getMyStoryFuture(String uid) async{
    final statusCollection =
    firebaseFirestore.collection(Constant.story)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));

    return statusCollection.get().then((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StoryModel.fromSnapshot(e))
        .toList());
  }

  @override
  Stream<List<StoryEntity>> getStory(StoryEntity story) {
    final storyCollection =
    firebaseFirestore.collection(Constant.story)
        .where(
        "createdAt",
        isGreaterThan: DateTime.now().subtract(
          const Duration(hours: 24),
        ));

    return storyCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StoryModel.fromSnapshot(e))
        .toList());
  }

  @override
  Future<void> seenStoryUpdate(String storyId, int imageIndex, String userId) async{
    try {
      final storyDocRef = firebaseFirestore
          .collection(Constant.story)
          .doc(storyId);

      final storyDoc = await storyDocRef.get();

      final stories = List<Map<String, dynamic>>.from(storyDoc.get('stories'));

      final viewersList = List<String>.from(stories[imageIndex]['viewers']);

      // Check if the user ID is already present in the viewers list
      if (!viewersList.contains(userId)) {
        viewersList.add(userId);

        // Update the viewers list for the specified image index
        stories[imageIndex]['viewers'] = viewersList;

        await storyDocRef.update({
          'stories': stories,
        });
      }


    } catch (error) {
      print('Error updating viewers list: $error');
    }
  }

  @override
  Future<void> updateOnlyImageStory(StoryEntity story) async{
    final storyCollection =
    firebaseFirestore.collection(Constant.story);

    final storyDocRef = await storyCollection.doc(story.storyId).get();

    try {
      if (storyDocRef.exists) {

        final existingStoryData = storyDocRef.data()!;
        final createdAt = existingStoryData['createdAt'].toDate();

        // check if the existing status is still within its 24 hours period
        if (createdAt.isAfter(DateTime.now().subtract(const Duration(hours: 24)))) {
          // if it is, update the existing status with the new stores (images, or videos)

          final stories = List<Map<String, dynamic>>.from(storyDocRef.get('stories'));

          stories.addAll(story.stories!.map((e) => StoryImageEntity.toJsonStatic(e)));
          // final updatedStories = List<StatusImageEntity>.from(existingStatusData['stories'])
          //   ..addAll(status.stories!);

          await storyCollection.doc(story.storyId).update({
            'stories': stories,
            'imageUrl': stories[0]['url']
          });
          return;
        }
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while updating status stories");
    }
  }

  @override
  Future<void> updateStory(StoryEntity story) async{
    final storyCollection =
    firebaseFirestore.collection(Constant.story);

    Map<String, dynamic> storyInfo = {};

    if (story.imageUrl != "" && story.imageUrl != null) {
      storyInfo['imageUrl'] = story.imageUrl;
    }

    if (story.stories != null) {
      storyInfo['stories'] = story.stories;
    }

    storyCollection.doc(story.storyId).update(storyInfo);
  }


  }
  
