import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StoryEntity extends Equatable {
  final String? storyId;
  final String? imageUrl;
  final String? uid;
  final String? username;
  final String? profileUrl;
  final Timestamp? createdAt;
  final String? description;
  final List<StoryImageEntity>? stories;

  StoryEntity(
      {
        this.storyId,
        this.imageUrl,
        this.uid,
        this.username,
        this.profileUrl,
        this.createdAt,
        this.description,
        this.stories
      });

  @override
  List<Object?> get props => [
    storyId,
    imageUrl,
    uid,
    username,
    profileUrl,
    createdAt,
    description,
    stories
  ];
}

class StoryImageEntity extends Equatable{

  final String? url;
  final String? type;
  final List<String>? viewers;

  StoryImageEntity({this.url, this.viewers, this.type});

  factory StoryImageEntity.fromJson(Map<String, dynamic> json) {
    return StoryImageEntity(
        url: json['url'],
        type: json['type'],
        viewers: List.from(json['viewers'])
    );
  }

  static Map<String, dynamic> toJsonStatic(StoryImageEntity storyImageEntity) => {
    "url": storyImageEntity.url,
    "viewers": storyImageEntity.viewers,
    "type": storyImageEntity.type,
  };
  Map<String, dynamic> toJson() => {
    "url": url,
    "viewers": viewers,
    "type": type,
  };

  @override
  List<Object?> get props => [
    url,
    viewers,
    type,
  ];
}