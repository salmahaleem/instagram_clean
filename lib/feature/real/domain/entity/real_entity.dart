import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RealEntity extends Equatable{
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

  RealEntity({
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
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    realId,
    creatorUid,
    username,
    description,
    realUrl,
    likes,
    saved,
    totalLikes,
    totalComments,
    createAt,
    userProfileUrl,
  ];

}