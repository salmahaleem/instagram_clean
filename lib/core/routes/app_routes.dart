import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart';
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

  static GoRouter route = GoRouter(
      routes: [

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
                )
        ),
        GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) {
              final String uid = "${state.pathParameters['id']}";
              return ProfilePage(uid: uid);
              // return MultiBlocProvider(
              //   providers: [
              //     BlocProvider(
              //       create: (_) => getIt<GetSingleUserCubit>(),
              //     ),
              //   ],
              //   child:
              // );
            }),

        GoRoute(
          path: '/editProfile',
          name: 'editProfile',
          builder: (context, state) => EditProfilePage(),
        ),

      ]);
}