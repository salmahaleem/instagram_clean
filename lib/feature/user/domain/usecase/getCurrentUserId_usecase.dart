import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class GetCurrentUserIdUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  GetCurrentUserIdUseCase({required this.userFirebaseRepo});

  Future<String> call()async{
    return await userFirebaseRepo.getCurrentUserId();
  }

}