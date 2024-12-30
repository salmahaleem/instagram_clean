
import 'dart:io';


class UserEntity {
  final String? uid;
  final String? username;
  final String? bio;
  final String? phone;
  final String? gender;
  final String? website;
  final String? email;
  late final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;

  // will not going to store in DB
  final File? imageFile;
  final String? password;
  final String? otherUid;

  UserEntity({
    this.imageFile,
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
    this.password,
    this.otherUid,
    this.totalPosts,
    this.phone,
    this.gender,
  });

  // @override
  // List<Object?> get props => [
  //   uid,
  //   username,
  //   bio,
  //   website,
  //   email,
  //   profileUrl,
  //   followers,
  //   following,
  //   totalFollowers,
  //   totalFollowing,
  //   password,
  //   otherUid,
  //   totalPosts,
  //   imageFile,
  //   phone,
  //   gender
  // ];
}