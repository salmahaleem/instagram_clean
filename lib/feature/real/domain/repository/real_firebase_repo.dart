import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';

abstract class RealFirebaseRepo{

  // Post Features
  Future<void> createReal(RealEntity real);
  Stream<List<RealEntity>> readReals(RealEntity real);
  Stream<List<RealEntity>> readSingleReal(String realId);
  Future<void> updateReal(RealEntity real);
  Future<void> deleteReal(RealEntity real);
  Future<void> likeReal(RealEntity real);
  Stream<List<RealEntity>> saveReal(RealEntity real);

}