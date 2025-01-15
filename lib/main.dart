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
import 'package:instagram_clean/feature/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:instagram_clean/feature/chat/presentation/cubit/message/message_cubit.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/cubit/comment_cubit.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/cubit/replay/replay_cubit.dart';

import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/get_single_real/single_real_cubit.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/real_cubit.dart';
import 'package:instagram_clean/feature/story/presentation/cubit/my_story/my_story_cubit.dart';
import 'package:instagram_clean/feature/story/presentation/cubit/stories/story_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_other_single_user/get_other_single_user_cubit.dart';
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
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
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
            BlocProvider(create: (_)=> di.getIt<GetOtherSingleUserCubit>()),
            BlocProvider(create: (_)=> di.getIt<PostCubit>()),
            BlocProvider(create: (_)=> di.getIt<RealCubit>()),
            BlocProvider(create: (_)=> di.getIt<SinglePostCubit>()),
            BlocProvider(create: (_)=> di.getIt<SingleRealCubit>()),
            BlocProvider(create: (_)=> di.getIt<CommentCubit>()),
            BlocProvider(create: (_)=> di.getIt<ReplayCubit>()),
            BlocProvider(create: (_)=> di.getIt<ChatCubit>()),
            BlocProvider(create: (_)=> di.getIt<MessageCubit>()),
            BlocProvider(create: (_)=> di.getIt<StoryCubit>()),
            BlocProvider(create: (_)=> di.getIt<MyStoryCubit>()),
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

