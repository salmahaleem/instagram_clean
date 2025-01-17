
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/repository/replay_firebase_repo.dart';

class LikeReplayUseCase {
  final ReplayFirebaseRepo replayFirebaseRepo;

  LikeReplayUseCase({required this.replayFirebaseRepo});

  Future<void> call(ReplayEntity replay) {
    return replayFirebaseRepo.likeReplay(replay);
  }
}