
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/repository/replay_firebase_repo.dart';

class ReadReplaysUseCase {
  final ReplayFirebaseRepo replayFirebaseRepo;

  ReadReplaysUseCase({required this.replayFirebaseRepo});

  Stream<List<ReplayEntity>> call(ReplayEntity replay) {
    return replayFirebaseRepo.readReplays(replay);
  }
}