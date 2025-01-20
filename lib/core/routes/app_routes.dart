import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/single_chat_page.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/screens/comment_post_page.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/screens/edit_comment_page.dart';
import 'package:instagram_clean/feature/comment_and_replay/presentation/screens/edit_replay_page.dart';
import 'package:instagram_clean/feature/home/domain/entity/app_entity.dart';
import 'package:instagram_clean/feature/home/presentation/screens/explore_page.dart';
import 'package:instagram_clean/feature/home/presentation/screens/main_page.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/screens/create_post_page.dart';
import 'package:instagram_clean/feature/post/presentation/screens/post_details.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/post_details_page.dart';
import 'package:instagram_clean/feature/post/presentation/screens/update_post_page.dart';
import 'package:instagram_clean/feature/splash/splash.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/signup_cubit/sign_up_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/screens/edit_profile_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/login_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/profile_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/signup_page.dart';
import 'package:instagram_clean/feature/user/presentation/screens/single_user_profile_page.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/followers_page.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/following_page.dart';
import 'package:instagram_clean/feature/user/presentation/widgets/profile_widgets/settings_menu.dart';

class AppRoutes {
  static GoRouter route = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: 'SplashPage',
      builder: (context, state) =>
          SplashPage(),
    ),

    GoRoute(
      path: '/login',
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
                  create: (_) => getIt<PostCubit>(),
                ),
                BlocProvider(
                  create: (_) => getIt<GetSingleUserCubit>(),
                ),
              ],
              child: ProfilePage(userEntity: currentUser),
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
                create: (_) => getIt<ProfileCubit>(),
              ),
            ],
            child: EditProfilePage(currentUser: currentUser),
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
        path: '/singleUserPage/:otherUserId',
        name: '/singleUserPage',
        builder: (context, state) {
          final otherUserId = state.pathParameters['otherUserId']!;
          //final UserEntity currentUser = state.extra as UserEntity;
          return SingleUserProfilePage(otherUserId: otherUserId);
        }),

    GoRoute(
        path: '/explorePage',
        name: 'explorePage',
        builder: (context, state) {
          return ExplorePage();
        }),
    GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) {
          final UserEntity currentUser = state.extra as UserEntity;
          return SettingsMenu(currentUser: currentUser);
        }),
    GoRoute(
        path: '/mainPage/:uid',
        name: 'mainPage',
        builder: (context, state) {
          final uid = state.pathParameters['uid'];
          return MainPage(uid: "${uid}");
        }),
    GoRoute(
        path: '/createPost',
        name: 'createPost',
        builder: (context, state) {
          final UserEntity currentUser = state.extra as UserEntity;
          return CreatePostPage(currentUser: currentUser);
        }
    ),
    GoRoute(
        path: '/postDetailsPage/:postId',
        name: 'postDetailsPage',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetail(postId: postId,);
        }
    ),

    GoRoute(
        path: '/updatePostPage',
        name: '/updatePostPage',
        builder: (context, state) {
          final PostEntity post = state.extra as PostEntity;
          return UpdatePostPage(post: post);
        }),

    GoRoute(
        path: '/commentPage',
        name: '/commentPage',
        builder: (context, state) {
          final postId = state.pathParameters['postId'];
          final uid = state.pathParameters['uid'];
          final AppEntity appEntity = state.extra as AppEntity;
          return CommentPage(appEntity: appEntity);
        }),

    GoRoute(
        path: '/editCommentPage',
        name: '/editCommentPage',
        builder: (context, state) {
          final CommentEntity comment = state.extra as CommentEntity;
          return EditCommentPage(comment: comment,);
        }),
    GoRoute(
        path: '/editReplayPage',
        name: '/editReplayPage',
        builder: (context, state) {
          final ReplayEntity replay = state.extra as ReplayEntity;
          return EditReplayPage(replay: replay);
        }),

    GoRoute(
        path: '/singleChatPage',
        name: '/singleChatPage',
        builder: (context, state) {
          final MessageEntity message = state.extra as MessageEntity;
          return SingleChatPage(message: message);
        }),

    GoRoute(
        path: '/FollowersPage',
        name:'/FollowersPage',
    builder: (context,state){
      final UserEntity currentUser = state.extra as UserEntity;
      return FollowersPage(user: currentUser,);
    }),
    GoRoute(
        path: '/FollowingPage',
        name:'/FollowingPage',
        builder: (context,state){
          final UserEntity currentUser = state.extra as UserEntity;
          return FollowingPage(user: currentUser,);
        }),
  ]
  );


}
