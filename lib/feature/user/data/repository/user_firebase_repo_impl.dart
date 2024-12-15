import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class UserFirebaseRepoImpl implements UserFirebaseRepo{
  final UserFirebaseRepo userFirebaseRepo;

  UserFirebaseRepoImpl({required this.userFirebaseRepo});
  @override
  Future<void> createUser(UserEntity user) async => await userFirebaseRepo.createUser(user);

  @override
  Future<void> followUnFollowUser(UserEntity user) async => await userFirebaseRepo.followUnFollowUser(user);

  @override
  Stream<List<UserEntity>> getAllUsers(UserEntity user) => userFirebaseRepo.getAllUsers(user);

  @override
  Future<String> getCurrentUserId() async => await userFirebaseRepo.getCurrentUserId();

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) => userFirebaseRepo.getSingleOtherUser(otherUid);

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) => userFirebaseRepo.getSingleUser(uid);


  @override
  Future<bool> isLogin() async => await userFirebaseRepo.isLogin();

  @override
  Future<void> login(UserEntity user) async => await userFirebaseRepo.login(user);

  @override
  Future<void> logout() async => await userFirebaseRepo.logout();

  @override
  Future<void> signup(UserEntity user) async => await userFirebaseRepo.signup(user);

  @override
  Future<void> updateUser(UserEntity user) async => await userFirebaseRepo.updateUser(user);

}