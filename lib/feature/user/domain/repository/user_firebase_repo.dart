import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';

abstract class UserFirebaseRepo{

  //User

  Future<void> login(UserEntity user);
  Future<void> signup(UserEntity user);
  Future<bool> isLogin();
  Future<void> logout();

  Stream<List<UserEntity>> getAllUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);

  Future<String> getCurrentUserId();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<void> followUnFollowUser(UserEntity user);

}