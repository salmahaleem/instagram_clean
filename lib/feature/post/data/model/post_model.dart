import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';

class PostModel extends PostEntity {

  final String? postId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final List<String>? saved;
  final num? totalLikes;
  final num? totalSaved;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  PostModel({
    this.postId,
    this.creatorUid,
    this.username,
    this.description,
    this.postImageUrl,
    this.likes,
    this.saved,
    this.totalLikes,
    this.totalSaved,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  }) : super(
    createAt: createAt,
    creatorUid: creatorUid,
    description: description,
    likes: likes,
    saved: saved,
    postId: postId,
    postImageUrl: postImageUrl,
    totalComments: totalComments,
    totalLikes: totalLikes,
    totalSaved: totalSaved,
    username: username,
    userProfileUrl: userProfileUrl,
  );

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      createAt: snapshot['createAt'] != null ? snapshot['createAt'] as Timestamp : null,
      creatorUid: snapshot['creatorUid'] ?? '',
      description: snapshot['description'] ?? '',
      userProfileUrl: snapshot['userProfileUrl'] ?? '',
      totalLikes: snapshot['totalLikes'] ?? 0,
      totalSaved: snapshot['totalSaved'] ?? 0,
      totalComments: snapshot['totalComments'] ?? 0,
      postImageUrl: snapshot['postImageUrl'] ?? '',
      postId: snapshot['postId'] ?? '',
      username: snapshot['username'] ?? '',
      likes:(snapshot['likes'] is List) ? List.from(snap.get("likes")) : [],
      saved:(snapshot['saved'] is List) ? List.from(snap.get("saved")) : [],
    );
  }

  Map<String, dynamic> toDocument() => {
    "createAt": createAt,
    "creatorUid": creatorUid,
    "description": description,
    "userProfileUrl": userProfileUrl,
    "totalLikes": totalLikes,
    "totalSaved":totalSaved,
    "totalComments": totalComments,
    "postImageUrl": postImageUrl,
    "postId": postId,
    "likes": likes,
    "saved":saved,
    "username": username,
  };
}