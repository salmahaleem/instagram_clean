import 'package:instagram_clean/feature/comment/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment/domain/repository/replay_firebase_repo.dart';

class UpdateReplayUseCase {
  final ReplayFirebaseRepo replayFirebaseRepo;

  UpdateReplayUseCase({required this.replayFirebaseRepo});

  Future<void> call(ReplayEntity replay) {
    return replayFirebaseRepo.updateReplay(replay);
  }
}