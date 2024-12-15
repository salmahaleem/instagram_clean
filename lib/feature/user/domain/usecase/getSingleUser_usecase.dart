import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class GetSingleUserUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  GetSingleUserUseCase({required this.userFirebaseRepo});

  Stream<List<UserEntity>> call(String uid){
    return userFirebaseRepo.getSingleUser(uid);
  }

}