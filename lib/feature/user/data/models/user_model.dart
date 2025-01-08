import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';

class UserModel extends UserEntity{
  final String? uid;
  final String? username;
  final String? bio;
  final String? phone;
  final String? gender;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;
  final bool? isOnline;

  UserModel({
    this.uid,
    this.username,
    this.bio,
    this.website,
    this.email,
    this.profileUrl,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
    this.totalPosts,
    this.phone,
    this.gender,
    this.isOnline

  }) : super(
    uid: uid,
    totalFollowing: totalFollowing,
    followers: followers,
    totalFollowers: totalFollowers,
    username: username,
    profileUrl: profileUrl,
    website: website,
    following: following,
    bio: bio,
    gender: gender,
    phone: phone,
    email: email,
    totalPosts: totalPosts,
    isOnline: isOnline,
  );

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    final snapshot = doc.data() as Map<String, dynamic>?;

    if (snapshot == null) {
      throw Exception("Document ${doc.id} data is null");
    }

    return UserModel(
      uid: snapshot['uid'] ?? '',
      email: snapshot['email'] ?? '',
      username: snapshot['username'] ?? '',
      bio: snapshot['bio'] ?? '',
      phone: snapshot['phone'] ?? '',
      gender: snapshot['gender'] ?? '',
      website: snapshot['website'] ?? '',
      profileUrl: snapshot['profileUrl'] ?? '',
      totalFollowers: snapshot['totalFollowers'] ?? 0,
      totalFollowing: snapshot['totalFollowing'] ?? 0,
      totalPosts: snapshot['totalPosts'] ?? 0,
      followers: (snapshot['followers'] is List) ? List.from(snapshot['followers']) : [],
      following: (snapshot['following'] is List) ? List.from(snapshot['following']) : [],
      isOnline: snapshot['isOnline'] ?? false
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid ?? '',
    "email": email ?? '',
    "gender": gender ?? '',
    "phone": phone ?? '',
    "username": username ?? '',
    "totalFollowers": totalFollowers ?? 0,
    "totalFollowing": totalFollowing ?? 0,
    "totalPosts": totalPosts ?? 0,
    "website": website ?? '',
    "bio": bio ?? '',
    "profileUrl": profileUrl ?? '',
    "followers": followers ?? [],
    "following": following ?? [],
    "isOnline" : isOnline ?? false
  };
}