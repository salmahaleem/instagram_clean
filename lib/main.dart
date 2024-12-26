import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/appLogic/languages/language_cubit.dart';
import 'package:instagram_clean/core/appLogic/theme/theme_cubit.dart';

import 'package:instagram_clean/core/routes/app_routes.dart';
import 'package:instagram_clean/core/shared/shared_pref.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/firebase_options.dart';
import 'package:instagram_clean/generated/codegenrated.dart';

import 'core/get_it/get_it.dart' as di;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );
  await EasyLocalization.ensureInitialized();
  await SharedPref.init();
  await di.setGetIt();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translate',
      fallbackLocale: const Locale('en'),
      assetLoader: CodeGenerated(),
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider(create: (_) => LanguageCubit()),
            BlocProvider(create: (_)=> di.getIt<GetSingleUserCubit>()),
            BlocProvider(create: (_)=> di.getIt<ProfileCubit>()),
          ], child: const MyApp())));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final themeData = themeState.themeData;
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, languageState) {
            final locale = languageState is LanguageChanged
                ? languageState.locale
                : const Locale('en');
            return ScreenUtilInit(
              //designSize: Size(375, 812),
                minTextAdapt: true,
                builder: (context, child) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    title: 'Instagram',
                    theme: themeData,
                    locale: locale,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    localeResolutionCallback: (locale, supportedLocales) {
                      return supportedLocales.contains(locale)
                          ? locale
                          : const Locale('en');
                    },
                    routerConfig: AppRoutes.route,
                  );
                }
            );
          },
        );
      },
    );
  }
}

