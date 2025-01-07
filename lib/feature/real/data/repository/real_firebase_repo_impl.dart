import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';

class RealFirebaseRepoImpl implements RealFirebaseRepo{
  final RealFirebaseRepo realFirebaseRepo;

  RealFirebaseRepoImpl({required this.realFirebaseRepo});
  @override
  Future<void> createReal(RealEntity real) async => realFirebaseRepo.createReal(real);

  @override
  Future<void> deleteReal(RealEntity real) async => realFirebaseRepo.deleteReal(real);

  @override
  Future<void> likeReal(RealEntity real) async => realFirebaseRepo.likeReal(real);

  @override
  Stream<List<RealEntity>> readReals(RealEntity real) => realFirebaseRepo.readReals(real);

  @override
  Stream<List<RealEntity>> readSingleReal(String realId)  => realFirebaseRepo.readSingleReal(realId);

  @override
  Stream<List<RealEntity>> saveReal(RealEntity real)  => realFirebaseRepo.saveReal(real);

  @override
  Future<void> updateReal(RealEntity real) async => realFirebaseRepo.updateReal(real);

}