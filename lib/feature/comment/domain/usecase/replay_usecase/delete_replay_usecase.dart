import 'package:instagram_clean/feature/comment/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment/domain/repository/replay_firebase_repo.dart';

class DeleteReplayUseCase {
  final ReplayFirebaseRepo replayFirebaseRepo;

  DeleteReplayUseCase({required this.replayFirebaseRepo});

  Future<void> call(ReplayEntity replay) {
    return replayFirebaseRepo.deleteReplay(replay);
  }
}