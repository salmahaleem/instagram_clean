import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';

class DeleteRealUseCase {
  final RealFirebaseRepo realFirebaseRepo;

  DeleteRealUseCase({required this.realFirebaseRepo});

  Future<void> call(RealEntity real) {
    return realFirebaseRepo.deleteReal(real);
  }
}