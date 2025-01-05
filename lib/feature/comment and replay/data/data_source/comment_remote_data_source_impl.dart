import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/data/model/comment_model.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/comment_firebase_repo.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class CommentRemoteDataSourceImpl implements CommentFirebaseRepo{
  final UserFirebaseRepo userFirebaseRepo;

  final FirebaseFirestore firebaseFirestore;

  CommentRemoteDataSourceImpl(
      {required this.firebaseFirestore, required this.userFirebaseRepo});
  @override
  Future<void> createComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(Constant.posts).doc(comment.postId).collection(Constant.comment);

    final newComment = CommentModel(
        userProfileUrl: comment.userProfileUrl,
        username: comment.username,
        totalReplays: comment.totalReplays,
        commentId: comment.commentId,
        postId: comment.postId,
        likes: [],
        description: comment.description,
        creatorUid: comment.creatorUid,
        createAt: comment.createAt
    ).toJson();

    try {

      final commentDocRef = await commentCollection.doc(comment.commentId).get();

      if (!commentDocRef.exists) {
        commentCollection.doc(comment.commentId).set(newComment).then((value) {

          final postCollection = firebaseFirestore.collection(Constant.posts).doc(comment.postId);

          postCollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postCollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        commentCollection.doc(comment.commentId).update(newComment);
      }


    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(Constant.posts).doc(comment.postId).collection(Constant.comment);

    try {
      commentCollection.doc(comment.commentId).delete().then((value) {
        final postCollection = firebaseFirestore.collection(Constant.posts).doc(comment.postId);

        postCollection.get().then((value) {
          if (value.exists) {
            final totalComments = value.get('totalComments');
            postCollection.update({"totalComments": totalComments - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }

  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(Constant.posts).doc(comment.postId).collection(Constant.comment);
    final currentUid = await userFirebaseRepo.getCurrentUserId();

    final commentRef = await commentCollection.doc(comment.commentId).get();

    if (commentRef.exists) {
      List likes = commentRef.get("likes");
      if (likes.contains(currentUid)) {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid])
        });
      } else {
        commentCollection.doc(comment.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid])
        });
      }

    }
  }

  @override
  Stream<List<CommentEntity>> readComments(String postId) {
    final commentCollection = firebaseFirestore.collection(Constant.posts).doc(postId).collection(Constant.comment).orderBy("createAt", descending: true);
    return commentCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => CommentModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore.collection(Constant.posts).doc(comment.postId).collection(Constant.comment);

    Map<String, dynamic> commentInfo = Map();

    if (comment.description != "" && comment.description != null) commentInfo["description"] = comment.description;

    commentCollection.doc(comment.commentId).update(commentInfo);
  }
}