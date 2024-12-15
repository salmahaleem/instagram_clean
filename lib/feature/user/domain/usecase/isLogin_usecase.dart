import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class IsLoginUseCase{
  final UserFirebaseRepo userFirebaseRepo;

  IsLoginUseCase({required this.userFirebaseRepo});

  Future<bool> call()async{
    return await userFirebaseRepo.isLogin();
  }

}