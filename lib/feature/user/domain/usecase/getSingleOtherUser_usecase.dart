import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class GetSingleOtherUserUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  GetSingleOtherUserUseCase({required this.userFirebaseRepo});

  Stream<List<UserEntity>> call(String otherUid){
    return userFirebaseRepo.getSingleOtherUser(otherUid);
  }

}