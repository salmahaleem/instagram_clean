import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/post/data/model/post_model.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class PostRemoteDataSourceImpl implements PostFirebaseRepo{
  final UserFirebaseRepo userFirebaseRepo;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  PostRemoteDataSourceImpl(
      { required this.userFirebaseRepo,
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.firebaseStorage,
  });

  @override
  Future<void> createPost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(Constant.posts);

    final newPost = PostModel(
        userProfileUrl: post.userProfileUrl,
        username: post.username,
        totalLikes: 0,
        totalSaved: 0,
        totalComments: 0,
        postImageUrl: post.postImageUrl,
        postId: post.postId,
        likes: [],
        saved: [],
        description: post.description,
        creatorUid: firebaseAuth.currentUser!.uid,
        createAt: post.createAt
    ).toDocument();

    try {

      final postDocRef = await postCollection.doc(post.postId).get();
      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newPost).then((value) {
          final userCollection = firebaseFirestore.collection(Constant.users).doc(post.creatorUid);
          userCollection.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get('totalPosts');
              userCollection.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newPost);
      }
    }catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(Constant.posts);

    try {
      postCollection.doc(post.postId).delete().then((value) {
        final userCollection = firebaseFirestore.collection(Constant.users).doc(post.creatorUid);

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
  Future<void> likePost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(Constant.posts);

    final currentUid = await userFirebaseRepo.getCurrentUserId();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totalLikes");
      if (likes.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totalLikes": totalLikes - 1
        });
      } else {
        postCollection.doc(post.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totalLikes": totalLikes + 1
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post) {
    final postCollection = firebaseFirestore.collection(Constant.posts).orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) {
    final postCollection = firebaseFirestore.collection(Constant.posts).orderBy("createAt", descending: true).where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(Constant.posts);
    Map<String, dynamic> postInfo = Map();

    if (post.description != "" && post.description != null) postInfo['description'] = post.description;
    if (post.postImageUrl != "" && post.postImageUrl != null) postInfo['postImageUrl'] = post.postImageUrl;

    postCollection.doc(post.postId).update(postInfo);
  }

  @override
  Future<void> savePost(PostEntity post) async{
    final postCollection = firebaseFirestore.collection(Constant.posts);

    final currentUid = await userFirebaseRepo.getCurrentUserId();
    final postRef = await postCollection.doc(post.postId).get();

    if (postRef.exists) {
      List saved = postRef.get("saved");
      final totalSaved = postRef.get("totalSaved");
      if (saved.contains(currentUid)) {
        postCollection.doc(post.postId).update({
          "saved": FieldValue.arrayRemove([currentUid]),
          "totalSaved": totalSaved - 1
        });
      } else {
        postCollection.doc(post.postId).update({
          "saved": FieldValue.arrayUnion([currentUid]),
          "totalSaved": totalSaved + 1
        });
      }
    }
  }





}
