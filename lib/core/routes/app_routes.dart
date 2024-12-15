
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/feature/user/presentation/screens/login_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/signup_page.dart';


class AppRoutes {
  static GoRouter route = GoRouter(
      routes: [

        GoRoute(
          path: '/',
          name: 'login',
          builder: (context, state) =>
              MultiBlocProvider(
                providers: [
                  //BlocProvider(create: (_) => getIt<LoginCubit>()),
                  // ... other providers
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
                   // BlocProvider(
                      //create: (_) => getIt<SignUpCubit>(),
                    //),
                  ],
                  child: SignupPage(),
                )
        ),

      ]);
}