import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class GetAllUsersUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  GetAllUsersUseCase({required this.userFirebaseRepo});

  Stream<List<UserEntity>> call(UserEntity user){
    return userFirebaseRepo.getAllUsers(user);
  }

}