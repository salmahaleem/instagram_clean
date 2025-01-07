import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';

class ReadRealsUseCase {
  final RealFirebaseRepo realFirebaseRepo;

  ReadRealsUseCase({required this.realFirebaseRepo});

  Stream<List<RealEntity>> call(RealEntity real) {
    return realFirebaseRepo.readReals(real);
  }
}