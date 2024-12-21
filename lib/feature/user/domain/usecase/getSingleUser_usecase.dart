import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class GetSingleUserUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  GetSingleUserUseCase({required this.userFirebaseRepo});

  Stream<List<UserEntity>> call(String uid){
    if (uid.isEmpty) {
      throw ArgumentError('UID cannot be empty');
    }
    return userFirebaseRepo.getSingleUser(uid);
  }

}