
import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/replay_firebase_repo.dart';

class CreateReplayUseCase {
  final ReplayFirebaseRepo replayFirebaseRepo;

  CreateReplayUseCase({required this.replayFirebaseRepo});

  Future<void> call(ReplayEntity replay) {
    return replayFirebaseRepo.createReplay(replay);
  }
}