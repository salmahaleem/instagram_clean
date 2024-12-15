import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  // Future<void> createUser(UserEntity user) async{
  //   final userCollection = firebaseFirestore.collection(Constant.users);
  //
  //   final uid = await getCurrentUserId();
  //
  //   userCollection.doc(uid).get().then((userDoc) {
  //     final newUser = UserModel(
  //         uid: uid,
  //         name: user.name,
  //         email: user.email,
  //         bio: user.bio,
  //         following: user.following,
  //         website: user.website,
  //         profileUrl: user.profileUrl,
  //         username: user.username,
  //         totalFollowers: user.totalFollowers,
  //         followers: user.followers,
  //         totalFollowing: user.totalFollowing,
  //         totalPosts: user.totalPosts
  //     ).toJson();
  //
  //     if (!userDoc.exists) {
  //       userCollection.doc(uid).set(newUser);
  //     } else {
  //       userCollection.doc(uid).update(newUser);
  //     }
  //   }).catchError((error) {
  //     print("error in createUser ");
  //   });
  // }

  @override
  Future<String> getCurrentUserId()async => await firebaseAuth.currentUser!.uid;

  @override
  Future<void> signup(UserEntity user) async{
    try{
      final credential = await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
      User? userCreate = credential.user;
      if(userCreate != null){
        await createUser(user);
      }
      //     .then((value)
      // {
      //   if(value.)
      // });
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        print("email is already exist");
      } else {
        print("wrong in signUp");
      }
    }
  }

  @override
  Future<void> login(UserEntity user) async{
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: user.email!, password: user.password!);
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
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }


  @override
  Future<void> followUnFollowUser(UserEntity user) {
    // TODO: implement followUnFollowUser
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getAllUsers(UserEntity user) {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }



  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    // TODO: implement getSingleOtherUser
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    // TODO: implement getSingleUser
    throw UnimplementedError();
  }


  @override
  Future<void> updateUser(UserEntity user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<void> createUser(UserEntity user) {
    // TODO: implement createUser
    throw UnimplementedError();
  }
}
