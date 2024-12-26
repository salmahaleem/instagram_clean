import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class CreateUserUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  CreateUserUseCase({required this.userFirebaseRepo});

  Future<void> call(UserEntity user,String profileUrl)async{
    return await userFirebaseRepo.createUser(user,profileUrl);
  }

}