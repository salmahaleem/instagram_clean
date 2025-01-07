import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';

class LikeRealUseCase {
  final RealFirebaseRepo realFirebaseRepo;

  LikeRealUseCase({required this.realFirebaseRepo});

  Future<void> call(RealEntity real) {
    return realFirebaseRepo.likeReal(real);
  }
}