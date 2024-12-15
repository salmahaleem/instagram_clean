import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class LoginUseCase {
  final UserFirebaseRepo userFirebaseRepo;

  LoginUseCase({required this.userFirebaseRepo});

  Future<void> call(UserEntity userEntity) async{
    return await userFirebaseRepo.login(userEntity);
  }
}