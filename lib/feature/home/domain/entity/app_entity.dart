import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';

class AppEntity {

  final UserEntity? currentUser;
  final PostEntity? postEntity;

  final String? uid;
  final String? postId;
  final String? realId;
  AppEntity({this.currentUser, this.postEntity, this.uid, this.postId,this.realId});
}