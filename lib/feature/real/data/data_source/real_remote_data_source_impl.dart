import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/real/data/model/real_model.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class RealRemoteDataSourceImpl implements RealFirebaseRepo{
  final UserFirebaseRepo userFirebaseRepo;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  RealRemoteDataSourceImpl({
    required this.userFirebaseRepo,
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.firebaseStorage,
  });

  @override
  Future<void> createReal(RealEntity real) async{
    final postCollection = firebaseFirestore.collection(Constant.reals);
    final userCollection = firebaseFirestore.collection(Constant.users);
    final username = await userCollection.doc(real.username).get();

    final newPost = RealModel(
        userProfileUrl: real.userProfileUrl,
        username: username.toString(),
        totalLikes: real.totalLikes,
        totalComments: real.totalComments,
        realUrl: real.realUrl,
        realId: real.realId,
        likes: [],
        description: real.description,
        creatorUid: firebaseAuth.currentUser!.uid,
        createAt: real.createAt
    ).toJson();

    try {

      final postDocRef = await postCollection.doc(real.realId).get();

      if (!postDocRef.exists) {
        postCollection.doc(real.realId).set(newPost).then((value) {
          final userCollection = firebaseFirestore.collection(Constant.users).doc(real.creatorUid);
          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get("totalPosts");
              userCollection.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(real.realId).update(newPost);
      }
    }catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deleteReal(RealEntity real) async{
    final postCollection = firebaseFirestore.collection(Constant.reals);

    try {
      postCollection.doc(real.realId).delete().then((value) {
        final userCollection = firebaseFirestore.collection(Constant.users).doc(real.creatorUid);

        userCollection.get().then((value) {
          if (value.exists) {
            final totalPosts = value.get('totalPosts');
            userCollection.update({"totalPosts": totalPosts - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReal(RealEntity real) async{
    final postCollection = firebaseFirestore.collection(Constant.reals);

    final currentUid = await userFirebaseRepo.getCurrentUserId();
    final postRef = await postCollection.doc(real.realId).get();

    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        postCollection.doc(real.realId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        postCollection.doc(real.realId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<RealEntity>> readReals(RealEntity real) {
    final postCollection = firebaseFirestore.collection(Constant.reals).orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => RealModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<RealEntity>> readSingleReal(String realId) {
    final postCollection = firebaseFirestore.collection(Constant.reals).orderBy("createAt", descending: true).where("postId", isEqualTo: realId);
    return postCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => RealModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<RealEntity>> saveReal(RealEntity real) {
    // TODO: implement saveReal
    throw UnimplementedError();
  }

  @override
  Future<void> updateReal(RealEntity real) async {
    final postCollection = firebaseFirestore.collection(Constant.reals);
    Map<String, dynamic> postInfo = Map();

    if (real.description != "" && real.description != null) postInfo['description'] = real.description;
    if (real.realUrl != "" && real.realUrl != null) postInfo['postImageUrl'] = real.realUrl;

    postCollection.doc(real.realId).update(postInfo);
  }

}