import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';

class RealModel extends RealEntity{
  final String? realId;
  final String? creatorUid;
  final String? username;
  final String? description;
  final String? realUrl;
  final List<String>? likes;
  final List<String>? saved;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;

  RealModel({
    this.realId,
    this.creatorUid,
    this.username,
    this.description,
    this.realUrl,
    this.likes,
    this.saved,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,
  }) : super(
    createAt: createAt,
    creatorUid: creatorUid,
    description: description,
    likes: likes,
    saved: saved,
    realId: realId,
    realUrl: realUrl,
    totalComments: totalComments,
    totalLikes: totalLikes,
    username: username,
    userProfileUrl: userProfileUrl,
  );

  factory RealModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return RealModel(
      createAt: snapshot['createAt'] != null ? snapshot['createAt'] as Timestamp : null,
      creatorUid: snapshot['creatorUid'] ?? '',
      description: snapshot['description'] ?? '',
      userProfileUrl: snapshot['userProfileUrl'] ?? '',
      totalLikes: snapshot['totalLikes'] ?? 0,
      totalComments: snapshot['totalComments'] ?? 0,
      realUrl: snapshot['realUrl'] ?? '',
      realId: snapshot['realId'] ?? '',
      username: snapshot['username'] ?? '',
      likes:(snapshot['likes'] is List) ? List.from(snap.get("likes")) : [],
      saved:(snapshot['saved'] is List) ? List.from(snap.get("saved")) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "createAt": createAt,
    "creatorUid": creatorUid,
    "description": description,
    "userProfileUrl": userProfileUrl,
    "totalLikes": totalLikes,
    "totalComments": totalComments,
    "realUrl": realUrl,
    "realId": realId,
    "likes": likes,
    "saved":saved,
    "username": username,
  };
}