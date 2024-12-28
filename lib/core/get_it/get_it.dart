import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clean/feature/post/data/data_source/post_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/post/data/repository/post_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/post/domain/repository/post_firebase_repo.dart';
import 'package:instagram_clean/feature/post/domain/usecase/create_post_usecase.dart';
import 'package:instagram_clean/feature/post/domain/usecase/delete_post_usecase.dart';
import 'package:instagram_clean/feature/post/domain/usecase/like_post_usecase.dart';
import 'package:instagram_clean/feature/post/domain/usecase/read_posts_usecase.dart';
import 'package:instagram_clean/feature/post/domain/usecase/read_single_post_usecase.dart';
import 'package:instagram_clean/feature/post/domain/usecase/save_post_usecase.dart';
import 'package:instagram_clean/feature/post/domain/usecase/update_post_usecase.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/user/data/data_source/user_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/user/data/repository/user_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getAllUsers_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getSingleOtherUser_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getSingleUser_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/isLogin_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/login_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/logout_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/signup_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/updateUser_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/uploadImageToStorage_usecase.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_other_single_user/get_other_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/signup_cubit/sign_up_cubit.dart';


final getIt = GetIt.instance;
final FirebaseAuth authe = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage firebaseStorage =FirebaseStorage.instance;

Future<void> setGetIt() async {
  //cubit user
  getIt.registerFactory<LoginCubit>(() => LoginCubit(
      loginUseCase: getIt<LoginUseCase>(),
      isLoginUseCase: getIt<IsLoginUseCase>(),
      getCurrentUserIdUseCase: getIt<GetCurrentUserIdUseCase>(),
      ));

  getIt.registerFactory<SignUpCubit>(() => SignUpCubit(signupUseCase: getIt<SignupUseCase>()));

  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(
      logoutUseCase: getIt<LogoutUseCase>(),
      updateUserUseCase: getIt<UpdateUserUseCase>(),
      getAllUsersUseCase: getIt<GetAllUsersUseCase>(),
  ));

  getIt.registerFactory<GetSingleUserCubit>(() => GetSingleUserCubit(
     getSingleUserUseCase: getIt<GetSingleUserUseCase>(),
  ));

  getIt.registerFactory<GetOtherSingleUserCubit>(() => GetOtherSingleUserCubit(
     getSingleOtherUserUseCase: getIt<GetSingleOtherUserUseCase>(),
  ));

  //cubit post
  getIt.registerFactory<PostCubit>(() => PostCubit(
      updatePostUseCase: getIt<UpdatePostUseCase>(),
      deletePostUseCase: getIt<DeletePostUseCase>(),
      likePostUseCase: getIt<LikePostUseCase>(),
      createPostUseCase:getIt<CreatePostUseCase>(),
      readPostUseCase: getIt<ReadPostsUseCase>()
  ));

  getIt.registerFactory<SinglePostCubit>(() => SinglePostCubit(
      readSinglePostUseCase: getIt<ReadSinglePostUseCase>()));

  //usecase user
  getIt.registerLazySingleton<LoginUseCase>(
          () => LoginUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<SignupUseCase>(
          () => SignupUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<IsLoginUseCase>(
          () => IsLoginUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<GetCurrentUserIdUseCase>(
          () => GetCurrentUserIdUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<LogoutUseCase>(
          () => LogoutUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<UpdateUserUseCase>(
          () => UpdateUserUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<GetAllUsersUseCase>(
          () => GetAllUsersUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<GetSingleUserUseCase>(
          () => GetSingleUserUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<GetSingleOtherUserUseCase>(
          () => GetSingleOtherUserUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));

  //upload usecase
  getIt.registerLazySingleton<UploadImageToStorageUseCase>(
          () => UploadImageToStorageUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));


  //usecase post
  getIt.registerLazySingleton<CreatePostUseCase>(
          () => CreatePostUseCase(postFirebaseRepo: getIt<PostFirebaseRepo>()));
  getIt.registerLazySingleton<DeletePostUseCase>(
          () => DeletePostUseCase(postFirebaseRepo: getIt<PostFirebaseRepo>()));
  getIt.registerLazySingleton<LikePostUseCase>(
          () => LikePostUseCase(postFirebaseRepo: getIt<PostFirebaseRepo>()));
  getIt.registerLazySingleton<ReadPostsUseCase>(
          () => ReadPostsUseCase(postFirebaseRepo: getIt<PostFirebaseRepo>()));
  getIt.registerLazySingleton<ReadSinglePostUseCase>(
          () => ReadSinglePostUseCase(postFirebaseRepo: getIt<PostFirebaseRepo>()));
  getIt.registerLazySingleton<UpdatePostUseCase>(
          () => UpdatePostUseCase(postFirebaseRepo: getIt<PostFirebaseRepo>()));
  getIt.registerLazySingleton<SavePostUseCase>(
          () => SavePostUseCase(postFirebaseRepo: getIt<PostFirebaseRepo>()));

  //repos user
  getIt.registerLazySingleton<UserFirebaseRepo>(
          () => UserFirebaseRepoImpl(userFirebaseRepo: getIt<UserRemoteDataSourceImpl>()));

  //repos post
  getIt.registerLazySingleton<PostFirebaseRepo>(
          () => PostFirebaseRepoImpl(postFirebaseRepo: getIt<PostRemoteDataSourceImpl>()));


  //remote user
  getIt.registerLazySingleton<UserRemoteDataSourceImpl>(() => UserRemoteDataSourceImpl(
    firebaseAuth: getIt<FirebaseAuth>(),
    firebaseFirestore: getIt<FirebaseFirestore>(),
    firebaseStorage: getIt<FirebaseStorage>(), // Ensure FirebaseStorage is registered if used
  ));

  //remote post
  getIt.registerLazySingleton<PostRemoteDataSourceImpl>(() => PostRemoteDataSourceImpl(
    firebaseAuth: getIt<FirebaseAuth>(),
    firebaseFirestore: getIt<FirebaseFirestore>(),
    firebaseStorage: getIt<FirebaseStorage>(),
  ));

  getIt.registerLazySingleton<FirebaseAuth>(() => authe);
  getIt.registerLazySingleton<FirebaseFirestore>(() => firestore);
  getIt.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);

}
