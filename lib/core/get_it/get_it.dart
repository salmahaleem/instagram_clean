import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
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
  //cubit
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

  //usecase
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


  //repos
  getIt.registerLazySingleton<UserFirebaseRepo>(
          () => UserFirebaseRepoImpl(userFirebaseRepo: getIt<UserRemoteDataSourceImpl>()));
  //remote
  getIt.registerLazySingleton<UserRemoteDataSourceImpl>(() => UserRemoteDataSourceImpl(
    firebaseAuth: getIt<FirebaseAuth>(),
    firebaseFirestore: getIt<FirebaseFirestore>(),
    firebaseStorage: getIt<FirebaseStorage>(), // Ensure FirebaseStorage is registered if used
  ));

  getIt.registerLazySingleton<FirebaseAuth>(() => authe);
  getIt.registerLazySingleton<FirebaseFirestore>(() => firestore);
  getIt.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);

}
