import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable{
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

  PostEntity({
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
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    postId,
    creatorUid,
    username,
    description,
    postImageUrl,
    likes,
    saved,
    totalSaved,
    totalLikes,
    totalComments,
    createAt,
    userProfileUrl,
  ];

}