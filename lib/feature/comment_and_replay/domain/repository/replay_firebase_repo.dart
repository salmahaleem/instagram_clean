

import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';

abstract class ReplayFirebaseRepo {

  Future<void> createReplay(ReplayEntity replay);
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay);
  Future<void> updateReplay(ReplayEntity replay);
  Future<void> deleteReplay(ReplayEntity replay);
  Future<void> likeReplay(ReplayEntity replay);
}