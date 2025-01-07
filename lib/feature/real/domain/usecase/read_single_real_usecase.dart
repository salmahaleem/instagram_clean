import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';

class ReadSingleRealUseCase {
  final RealFirebaseRepo realFirebaseRepo;

  ReadSingleRealUseCase({required this.realFirebaseRepo});

  Stream<List<RealEntity>> call(String realId) {
    return realFirebaseRepo.readSingleReal(realId);
  }
}