import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class UpdateUserUseCase {
  final UserFirebaseRepo userFirebaseRepo;

  UpdateUserUseCase({required this.userFirebaseRepo});

  Future<void> call(UserEntity user)async{
    return await userFirebaseRepo.updateUser(user);
  }

}