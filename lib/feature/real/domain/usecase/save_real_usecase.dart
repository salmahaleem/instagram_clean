import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';

class SaveRealUseCase {
  final RealFirebaseRepo realFirebaseRepo;

  SaveRealUseCase({required this.realFirebaseRepo});

  Stream<List<RealEntity>> call(RealEntity real) {
    return realFirebaseRepo.saveReal(real);
  }
}