import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/home/presentation/screens/main_page.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/signup_cubit/sign_up_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/screens/edit_profile_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/login_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/profile_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/signup_page.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/settings_menu.dart';

class AppRoutes {
  static GoRouter route = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) =>
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<LoginCubit>()),
            ],
            child: LoginPage(),
          ),
    ),
    GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) =>
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<SignUpCubit>(),
                ),
              ],
              child: SignupPage(),
            )),
    GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) {
          if (state.extra is UserEntity) {
            final UserEntity currentUser = state.extra as UserEntity;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<GetSingleUserCubit>(),
                ),
              ],
              child: ProfilePage(currentUser: currentUser),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
    GoRoute(
      path: '/editProfile',
      name: 'editProfile',
      builder: (context, state) {
        if (state.extra is UserEntity) {
          final UserEntity currentUser = state.extra as UserEntity;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<ProfileCubit>()..updateUser(user: currentUser),
              ),
            ],
            child: EditProfilePage(userEntity: currentUser),
          );
        } else {
          print('Error: state.extra is not a UserEntity');
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text(
                'Invalid user data provided for editing the profile.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        }
      },
    ),
    GoRoute(
        path: '/settings',
        name: '/settings',
        builder: (context, state) {
          return SettingsMenu();
        }),
    GoRoute(
        path: '/mainPage',
        name: 'mainPage',
        builder: (context, state) {
          return MainPage(uid: "${Constant.userEntity.uid}");
        }),
  ]);
}
