import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';

class StoryModel extends StoryEntity {

  final String? storyId;
  final String? imageUrl;
  final String? uid;
  final String? username;
  final String? profileUrl;
  final Timestamp? createdAt;
  final String? description;
  final List<StoryImageEntity>? stories;

  StoryModel(
      {this.storyId,
        this.imageUrl,
        this.uid,
        this.username,
        this.profileUrl,
        this.createdAt,
        this.description,
        this.stories}) : super(
      storyId: storyId,
      imageUrl: imageUrl,
      uid: uid,
      username: username,
      profileUrl: profileUrl,
      createdAt: createdAt,
     description: description,
      stories: stories
  );

  factory StoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;

    final stories = snap['stories'] as List;
    List<StoryImageEntity> storiesData =
    stories.map((element) => StoryImageEntity.fromJson(element)).toList();

    return StoryModel(
        stories: storiesData,
        storyId: snap['storyId'],
        username: snap['username'],
        createdAt: snap['createdAt'],
        uid: snap['uid'],
        profileUrl: snap['profileUrl'],
        imageUrl: snap['imageUrl'],
        description: snap['description']
    );
  }

  Map<String, dynamic> toDocument() => {
    "stories": stories?.map((story) => story.toJson()).toList(),
    "storyId": storyId,
    "username": username,
    "createdAt": createdAt,
    "uid": uid,
    "profileUrl": profileUrl,
    "imageUrl": imageUrl,
    "description": description,
  };
}