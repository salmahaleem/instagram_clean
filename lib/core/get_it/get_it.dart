import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clean/feature/user/data/data_source/user_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/user/data/repository/user_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/isLogin_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/login_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/signup_usecase.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/signup_cubit/sign_up_cubit.dart';
//

final getIt = GetIt.instance;
final FirebaseAuth authe = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

void setGetIt() {
  //cubit
  getIt.registerFactory(() => LoginCubit(
      loginUseCase: getIt.call(),
      isLoginUseCase: getIt.call(),
      getCurrentUserIdUseCase: getIt.call()));
  getIt.registerFactory(() => SignUpCubit(signupUseCase: getIt.call()));

  //usecase
  getIt.registerLazySingleton(
      () => LoginUseCase(userFirebaseRepo: getIt.call()));
  getIt.registerLazySingleton(
      () => SignupUseCase(userFirebaseRepo: getIt.call()));
  getIt.registerLazySingleton(
      () => IsLoginUseCase(userFirebaseRepo: getIt.call()));
  getIt.registerLazySingleton(
      () => GetCurrentUserIdUseCase(userFirebaseRepo: getIt.call()));

  //repos
  getIt.registerLazySingleton(
      () => UserFirebaseRepoImpl(userFirebaseRepo: getIt.call()));
  //remote
  getIt.registerLazySingleton(() => UserRemoteDataSourceImpl(
      firebaseAuth: getIt.call(),
      firebaseFirestore: getIt.call(),
      firebaseStorage: getIt.call()));

  getIt.registerLazySingleton(() => authe);
  getIt.registerLazySingleton(() => firestore);
}
