import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/comment_and_replay/data/model/replay_model.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/repository/replay_firebase_repo.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class ReplayRemoteDataSourceImpl implements ReplayFirebaseRepo{
  final UserFirebaseRepo userFirebaseRepo;

  final FirebaseFirestore firebaseFirestore;

  ReplayRemoteDataSourceImpl(
      {required this.firebaseFirestore,required this.userFirebaseRepo});

  @override
  Future<void> createReplay(ReplayEntity replay) async{
    final replayCollection = firebaseFirestore.collection(Constant.posts).doc(replay.postId).collection(Constant.comment).doc(replay.commentId).collection(Constant.replay);

    final newReplay = ReplayModel(
        userProfileUrl: replay.userProfileUrl,
        username: replay.username,
        replayId: replay.replayId,
        commentId: replay.commentId,
        postId: replay.postId,
        likes: [],
        description: replay.description,
        creatorUid: replay.creatorUid,
        createAt: replay.createAt
    ).toJson();


    try {

      final replayDocRef = await replayCollection.doc(replay.replayId).get();

      if (!replayDocRef.exists) {
        replayCollection.doc(replay.replayId).set(newReplay).then((value) {
          final commentCollection = firebaseFirestore.collection(Constant.posts).doc(replay.postId).collection(Constant.comment).doc(replay.commentId);

          commentCollection.get().then((value) {
            if (value.exists) {
              final totalReplays = value.get('totalReplays');
              commentCollection.update({"totalReplays": totalReplays + 1});
              return;
            }
          });
        });
      } else {
        replayCollection.doc(replay.replayId).update(newReplay);
      }

    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteReplay(ReplayEntity replay) async{
    final replayCollection = firebaseFirestore.collection(Constant.posts).doc(replay.postId).collection(Constant.comment).doc(replay.commentId).collection(Constant.replay);

    try {
      replayCollection.doc(replay.replayId).delete().then((value) {
        final commentCollection = firebaseFirestore.collection(Constant.posts).doc(replay.postId).collection(Constant.comment).doc(replay.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplays = value.get('totalReplays');
            commentCollection.update({"totalReplays": totalReplays - 1});
            return;
          }
        });
      });
    } catch(e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReplay(ReplayEntity replay)async {
    final replayCollection = firebaseFirestore.collection(Constant.posts).doc(replay.postId).collection(Constant.comment).doc(replay.commentId).collection(Constant.replay);

    final currentUid = await userFirebaseRepo.getCurrentUserId();

    final replayRef = await replayCollection.doc(replay.replayId).get();

    if (replayRef.exists) {
      List likes = replayRef.get("likes");
      if (likes.contains(currentUid)) {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        replayCollection.doc(replay.replayId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }
    }
  }

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay) {
    final replayCollection = firebaseFirestore.collection(Constant.posts).doc(replay.postId).collection(Constant.comment).doc(replay.commentId).collection(Constant.replay);
    return replayCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => ReplayModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateReplay(ReplayEntity replay) async{
    final replayCollection = firebaseFirestore.collection(Constant.posts).doc(replay.postId).collection(Constant.comment).doc(replay.commentId).collection(Constant.replay);

    Map<String, dynamic> replayInfo = Map();

    if (replay.description != "" && replay.description != null) replayInfo['description'] = replay.description;

    replayCollection.doc(replay.replayId).update(replayInfo);
  }
  
}