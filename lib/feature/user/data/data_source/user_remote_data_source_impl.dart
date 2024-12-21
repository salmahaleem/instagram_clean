import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/user/data/models/user_model.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';

class UserRemoteDataSourceImpl implements UserFirebaseRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  UserRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.firebaseStorage,
  });

  @override
  Future<void> createUser(UserEntity user) async {
    try {
      final userCollection = firebaseFirestore.collection(Constant.users);
      final uid = await getCurrentUserId();

      final newUser = UserModel(
        uid: uid,
        email: user.email,
        phone: user.phone,
        gender: user.gender,
        bio: user.bio,
        following: user.following,
        website: user.website,
        profileUrl: user.profileUrl,
        username: user.username,
        totalFollowers: user.totalFollowers,
        followers: user.followers,
        totalFollowing: user.totalFollowing,
        totalPosts: user.totalPosts,
      ).toJson();

      // Use `set` with `merge: true` to update or create without needing a read
      await userCollection.doc(uid).set(newUser, SetOptions(merge: true));
    } catch (error) {
      print("Error in createUser: $error");
      rethrow; // Propagate error up for better handling in higher layers
    }
  }

  @override
  Future<String> getCurrentUserId() async =>
      await firebaseAuth.currentUser!.uid;

  @override
  Future<void> signup(UserEntity user) async {
    try {
      // Input validation
      if (user.email == null || user.email!.isEmpty) {
        throw Exception("Email must not be empty.");
      }

      if (user.password == null || user.password!.isEmpty) {
        throw Exception("Password must not be empty.");
      }
      // Attempt to create a new user with Firebase Authentication
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      // If the user was successfully created, save their data to Firestore
      if (result.user?.uid != null) {
        await createUser(user); // Create user profile in Firestore
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      switch (e.code) {
        case "email-already-in-use":
          throw Exception(
              "This email is already in use. Please try a different email.");
        case "weak-password":
          throw Exception(
              "The password provided is too weak. Please use a stronger password.");
        default:
          throw Exception(
              "Sign-up failed: ${e.message ?? "Unknown error occurred."}");
      }
    } catch (error) {
      // Handle unexpected errors
      throw Exception("An unexpected error occurred during sign-up: $error");
    }
    // try {
    //   if (user.email == null || user.password == null) {
    //     throw Exception("Email and password must not be null.");
    //   }
    //
    //   final result = await firebaseAuth.createUserWithEmailAndPassword(
    //     email: user.email!,
    //     password: user.password!,
    //   );
    //
    //   if (result.user?.uid != null) {
    //     await createUser(user); // Create user profile in Firestore
    //   }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == "email-already-in-use") {
    //     print("Error: Email already exists.");
    //   } else {
    //     print("Error during sign-up: ${e.message}");
    //   }
    //   rethrow; // Propagate error for handling at a higher level
    // } catch (error) {
    //   print("Unexpected error during sign-up: $error");
    //   rethrow;
    // }

  }

  @override
  Future<void> login(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        print("enter your email and password");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("user not found");
      } else if (e.code == "wrong-password") {
        print("Invalid email or password");
      }
    }
  }

  @override
  Future<bool> isLogin() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> logout() async{
    await firebaseAuth.signOut();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    if (uid.isEmpty) {
      throw ArgumentError('UID cannot be empty');
    }
    final userCollection = firebaseFirestore.collection(Constant.users)
        .where("uid", isEqualTo: uid);
    return userCollection.snapshots()
        .map((querySnapshot) {
      try {
        return querySnapshot.docs
            .map((doc) => UserModel.fromSnapshot(doc)) // Map Firestore docs to UserModel
            .toList();
      } catch (e) {
        // Log or handle parsing errors
        throw Exception('Failed to parse user data: $e');
      }
  }
    );
    }
  @override
  Stream<List<UserEntity>> getAllUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(Constant.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore.collection(Constant.users).where("uid", isEqualTo: otherUid).limit(1);
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) {
    // TODO: implement followUnFollowUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(UserEntity user) async{
    final userCollection = firebaseFirestore.collection(Constant.users);
    Map<String, dynamic> userInformation = Map();

    if (user.username != "" && user.username != null) userInformation['username'] = user.username;

    if (user.website != "" && user.website != null) userInformation['website'] = user.website;

    if (user.profileUrl != "" && user.profileUrl != null) userInformation['profileUrl'] = user.profileUrl;

    if (user.bio != "" && user.bio != null) userInformation['bio'] = user.bio;

    if (user.totalFollowing != null) userInformation['totalFollowing'] = user.totalFollowing;

    if (user.totalFollowers != null) userInformation['totalFollowers'] = user.totalFollowers;

    if (user.totalPosts != null) userInformation['totalPosts'] = user.totalPosts;


    userCollection.doc(user.uid).update(userInformation);
  }
}

