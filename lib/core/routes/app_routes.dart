import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/single_chat_page.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/comment_entity.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/entity/replay_entity.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/screens/comment_post_page.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/screens/edit_comment_page.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/screens/edit_replay_page.dart';
import 'package:instagram_clean/feature/home/domain/entity/app_entity.dart';
import 'package:instagram_clean/feature/home/presentation/screens/explore_page.dart';
import 'package:instagram_clean/feature/home/presentation/screens/main_page.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/screens/post_details_page.dart';
import 'package:instagram_clean/feature/post/presentation/screens/update_post_page.dart';
import 'package:instagram_clean/feature/post/presentation/widgets/create_post_widget.dart';
import 'package:instagram_clean/feature/story/presentation/widget/story_body.dart';
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
          return SettingsMenu();
        }),
    GoRoute(
        path: '/mainPage',
        name: 'mainPage',
        builder: (context, state) {
          return MainPage(uid: "${Constant.userEntity.uid}");
        }),
    GoRoute(
        path: '/createPost',
        name: 'createPost',
        builder: (context, state) {
          final UserEntity currentUser = state.extra as UserEntity;
          return MultiBlocProvider(
            providers: [
              BlocProvider<PostCubit>(
                create: (_) => getIt<PostCubit>(),
              ),
            ],
            child: CreatePostWidget(userEntity: currentUser),
          );
        }
    ),
    GoRoute(
        path: '/postDetailsPage/:postId',
        name: 'postDetailsPage',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return MultiBlocProvider(
            providers: [
              BlocProvider<SinglePostCubit>(
                create: (_) => getIt<SinglePostCubit>(),
              ),
              BlocProvider<PostCubit>(
                create: (_) => getIt<PostCubit>(),
              ),
            ],
            child: PostDetailsPage(postId: postId,),
          );
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
    // GoRoute(path: '/',
    // name:'/bodyStory',
    // builder: (context,state){
    //   return StoryBody();
    // })

  ]
  );


}
