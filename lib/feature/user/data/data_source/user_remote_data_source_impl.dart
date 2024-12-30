import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/user/data/models/user_model.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';
import 'package:uuid/uuid.dart';

class UserRemoteDataSourceImpl implements UserFirebaseRepo {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  UserRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.firebaseStorage,
  });

  // Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
  //   try {
  //     final userCollection = firebaseFirestore.collection(Constant.users);
  //
  //     // Get the current user ID
  //     final uid = await getCurrentUserId();
  //
  //     // Check if the user document exists
  //     final userDoc = await userCollection.doc(uid).get();
  //
  //     // Convert UserEntity to a map
  //     final newUser = UserModel(
  //       uid: uid,
  //       email: user.email,
  //       bio: user.bio,
  //       following: user.following,
  //       website: user.website,
  //       profileUrl: profileUrl,
  //       username: user.username,
  //       totalFollowers: user.totalFollowers,
  //       followers: user.followers,
  //       totalFollowing: user.totalFollowing,
  //       totalPosts: user.totalPosts,
  //     ).toJson();
  //
  //     if (!userDoc.exists) {
  //       // Create a new user if the document doesn't exist
  //       await userCollection.doc(uid).set(newUser);
  //       print("User created successfully.");
  //     } else {
  //       // Update the existing user document
  //       await userCollection.doc(uid).update(newUser);
  //       print("User updated successfully.");
  //     }
  //   } catch (e) {
  //     // Handle any errors that occur during the process
  //     print("Error creating/updating user: $e");
  //     throw Exception("Failed to create/update user: ${e.toString()}");
  //   }
  // }

  @override
  Future<void> createUser(UserEntity user, String profileUrl) async {
    try {
      final userCollection = firebaseFirestore.collection(Constant.users);

      final uid = await getCurrentUserId();

      userCollection.doc(uid).get().then((userDoc) {
        final newUser = UserModel(
            uid: uid,
            email: user.email,
            bio: user.bio,
            phone: user.phone,
            gender: user.gender,
            following: user.following,
            website: user.website,
            profileUrl: profileUrl,
            username: user.username,
            totalFollowers: user.totalFollowers,
            followers: user.followers,
            totalFollowing: user.totalFollowing,
            totalPosts: user.totalPosts
        ).toJson();

        if (!userDoc.exists) {
          userCollection.doc(uid).set(newUser);
        } else {
          userCollection.doc(uid).update(newUser);
        }
      }).catchError((error) {
        print("Some error occur");
      });
    } catch (error) {
      print("Error creating/updating user: $error");
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
      final currentuser = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      final userId = currentuser.user?.uid;
      if (userId == null) {
        throw Exception("User ID could not be generated. Sign-up failed.");
      }

      // Handle profile image upload and user creation

      if (userId != null) {
        // String profileUrl = " ";
        if (user.imageFile != null) {
           await uploadImageToStorage(user.imageFile!, false, "profileImages").then((profileUrl) async{
            await createUser(user, profileUrl);
          });

        }else{
         await createUser(user, " ");
        }
      }
      return;
      // Create user in the database
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
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    if (uid.isEmpty) {
      throw ArgumentError('UID cannot be empty');
    }
    final userCollection = firebaseFirestore
        .collection(Constant.users)
        .where("uid", isEqualTo: uid);
    return userCollection.snapshots().map((querySnapshot) {
      try {
        // Ensure the snapshot contains valid documents
        if (querySnapshot.docs.isEmpty) {
          throw Exception("No documents found for UID: $uid");
        }
        // Parse each document and filter out null or invalid entries
        return querySnapshot.docs.map((doc) {
          final data = doc.data(); // Get document data
          if (data == null) {
            throw Exception("Document data is null for doc ID: ${doc.id}");
          }
          return UserModel.fromSnapshot(doc); // Convert to UserModel
        }).toList();
      } catch (e, stacktrace) {
        // Log the error and rethrow it
        print("Error parsing Firestore documents: $e");
        print("Stacktrace: $stacktrace");
        throw Exception('Failed to parse user data: $e');
      }
    });
  }

  @override
  Stream<List<UserEntity>> getAllUsers(UserEntity user) {
    final userCollection = firebaseFirestore.collection(Constant.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    final userCollection = firebaseFirestore
        .collection(Constant.users)
        .where("uid", isEqualTo: otherUid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> followUnFollowUser(UserEntity user) {
    // TODO: implement followUnFollowUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firebaseFirestore.collection(Constant.users);
    Map<String, dynamic> userInformation = Map();

    if (user.profileUrl != null && user.profileUrl!.isNotEmpty) {
      userInformation['profileUrl'] = user.profileUrl;
    }

    if (user.username != null && user.username!.isNotEmpty) {
      userInformation['username'] = user.username;
    }

    if (user.website != null && user.website!.isNotEmpty) {
      userInformation['website'] = user.website;
    }

    if (user.bio != null && user.bio!.isNotEmpty) {
      userInformation['bio'] = user.bio;
    }

    if (user.email != null && user.email!.isNotEmpty) {
      userInformation['email'] = user.email;
    }

    if (user.gender != null && user.gender!.isNotEmpty) {
      userInformation['gender'] = user.gender;
    }

    if (user.phone != null && user.phone!.isNotEmpty) {
      userInformation['phone'] = user.phone;
    }
    if (user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }
    if (user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }
    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }

    try {
      // Ensure that the uid is not null or empty
      if (user.uid == null || user.uid!.isEmpty) {
        throw Exception("User ID is null or empty");
      }

      // Perform the update
      await userCollection.doc(user.uid).update(userInformation);

      // Log success
      print(
          "User ${user.uid} updated successfully with data: $userInformation");
    } catch (e) {
      // Handle and log any errors
      print("Failed to update user: $e");
      throw Exception("Failed to update user: $e");
    }
  }


  @override
  Future<String> uploadImageToStorage(File? file, bool isPost, String childName) async {

    Reference ref = firebaseStorage.ref().child(childName).child(firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    final uploadTask = ref.putFile(file!);

    final imageUrl = (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    return await imageUrl;
  }

}
