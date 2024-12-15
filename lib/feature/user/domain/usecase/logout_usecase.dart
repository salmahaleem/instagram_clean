import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class LogoutUseCase {
  final UserFirebaseRepo userFirebaseRepo;

  LogoutUseCase({required this.userFirebaseRepo});

  Future<void> call() async{
    return await userFirebaseRepo.logout();
}


}