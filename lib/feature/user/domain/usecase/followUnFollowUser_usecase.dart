import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class FollowUnFollowUserUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  FollowUnFollowUserUseCase({required this.userFirebaseRepo});

  Future<void> call(UserEntity user)async{
    return await userFirebaseRepo.followUnFollowUser(user);
  }

}