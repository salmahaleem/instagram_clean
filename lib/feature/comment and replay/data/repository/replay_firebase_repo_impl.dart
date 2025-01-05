
import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/replay_firebase_repo.dart';

class ReplayFirebaseRepoImpl implements ReplayFirebaseRepo{
  final ReplayFirebaseRepo replayFirebaseRepo;

  ReplayFirebaseRepoImpl({required this.replayFirebaseRepo});
  @override
  Future<void> createReplay(ReplayEntity replay) async => replayFirebaseRepo.createReplay(replay);

  @override
  Future<void> deleteReplay(ReplayEntity replay) async => replayFirebaseRepo.deleteReplay(replay);

  @override
  Future<void> likeReplay(ReplayEntity replay) async => replayFirebaseRepo.likeReplay(replay);

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) => replayFirebaseRepo.readReplays(replay);

  @override
  Future<void> updateReplay(ReplayEntity replay) async => replayFirebaseRepo.updateReplay(replay);


}