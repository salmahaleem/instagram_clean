
import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/replay_firebase_repo.dart';

class ReadReplaysUseCase {
  final ReplayFirebaseRepo replayFirebaseRepo;

  ReadReplaysUseCase({required this.replayFirebaseRepo});

  Stream<List<ReplayEntity>> call(ReplayEntity replay) {
    return replayFirebaseRepo.readReplays(replay);
  }
}