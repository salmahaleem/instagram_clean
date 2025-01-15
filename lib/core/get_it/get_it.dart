import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clean/feature/chat/data/data_source/chat_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/chat/data/repository/chat_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/delete_chat_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/detete_message_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/get_message_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/get_my_chat_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/seen_message_update_usecase.dart';
import 'package:instagram_clean/feature/chat/domain/usecase/send_message_usecase.dart';
import 'package:instagram_clean/feature/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/data/data_source/comment_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/data/data_source/replay_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/data/repository/comment_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/data/repository/replay_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/comment_firebase_repo.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/repository/replay_firebase_repo.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/comment_usecase/createComment_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/comment_usecase/deleteComment_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/comment_usecase/likeComment_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/comment_usecase/readComment_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/comment_usecase/updateComment_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/replay_usecase/create_replay_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/replay_usecase/delete_replay_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/replay_usecase/like_replay_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/replay_usecase/read_replay_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/domain/usecase/replay_usecase/update_replay_usecase.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/cubit/comment_cubit.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/cubit/replay/replay_cubit.dart';
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
import 'package:instagram_clean/feature/real/data/data_source/real_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/real/data/repository/real_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/real/domain/repository/real_firebase_repo.dart';
import 'package:instagram_clean/feature/real/domain/usecase/create_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/delete_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/like_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/read_reals_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/read_single_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/save_real_usecase.dart';
import 'package:instagram_clean/feature/real/domain/usecase/update_real_usecase.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/get_single_real/single_real_cubit.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/real_cubit.dart';
import 'package:instagram_clean/feature/story/data/data_source/story_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/story/data/repository/story_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/story/domain/repository/story_firebase_repo.dart';
import 'package:instagram_clean/feature/story/domain/usecase/create_story_usecase.dart';
import 'package:instagram_clean/feature/story/domain/usecase/delete_story_usecase.dart';
import 'package:instagram_clean/feature/story/domain/usecase/get_my_story.dart';
import 'package:instagram_clean/feature/story/domain/usecase/get_my_story_future.dart';
import 'package:instagram_clean/feature/story/domain/usecase/get_story_usecase.dart';
import 'package:instagram_clean/feature/story/domain/usecase/seen_story_update.dart';
import 'package:instagram_clean/feature/story/domain/usecase/update_only_image_story.dart';
import 'package:instagram_clean/feature/story/domain/usecase/update_story.dart';
import 'package:instagram_clean/feature/story/presentation/cubit/my_story/my_story_cubit.dart';
import 'package:instagram_clean/feature/story/presentation/cubit/stories/story_cubit.dart';
import 'package:instagram_clean/feature/user/data/data_source/user_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/user/data/repository/user_firebase_repo_impl.dart';
import 'package:instagram_clean/feature/user/domain/repository/user_firebase_repo.dart';
import 'package:instagram_clean/feature/user/domain/usecase/createUser_usecase.dart';
import 'package:instagram_clean/feature/user/domain/usecase/followUnFollowUser_usecase.dart';
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

import '../../feature/chat/presentation/cubit/message/message_cubit.dart';



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
      followUnFollowUserUseCase: getIt<FollowUnFollowUserUseCase>(),
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

//cubit real
  getIt.registerFactory<RealCubit>(() => RealCubit(
      updateRealUseCase: getIt<UpdateRealUseCase>(),
      deleteRealUseCase: getIt<DeleteRealUseCase>(),
      likeRealUseCase: getIt<LikeRealUseCase>(),
      createRealUseCase:getIt<CreateRealUseCase>(),
      readRealUseCase: getIt<ReadRealsUseCase>()
  ));

  getIt.registerFactory<SingleRealCubit>(() => SingleRealCubit(
      readSingleRealUseCase: getIt<ReadSingleRealUseCase>()));

  //comment and replay cubit
  getIt.registerFactory<CommentCubit>(() => CommentCubit(
       updateCommentUseCase: getIt<UpdateCommentUseCase>(),
       readCommentsUseCase: getIt<ReadCommentsUseCase>(),
       likeCommentUseCase: getIt<LikeCommentUseCase>(),
       deleteCommentUseCase: getIt<DeleteCommentUseCase>(),
       createCommentUseCase: getIt<CreateCommentUseCase>()
  ));

  getIt.registerFactory<ReplayCubit>(() => ReplayCubit(
      updateReplayUseCase: getIt<UpdateReplayUseCase>(),
      readReplaysUseCase: getIt<ReadReplaysUseCase>(),
      likeReplayUseCase: getIt<LikeReplayUseCase>(),
      deleteReplayUseCase: getIt<DeleteReplayUseCase>(),
      createReplayUseCase: getIt<CreateReplayUseCase>()
  ));

  //chat cubit
  getIt.registerFactory<ChatCubit>(() => ChatCubit(
      getMyChatUseCase: getIt<GetMyChatUseCase>(),
      deleteChatUseCase: getIt<DeleteChatUseCase>()
  ));

  getIt.registerFactory<MessageCubit>(() => MessageCubit(
      getMessagesUseCase: getIt<GetMessagesUseCase>(),
      deleteMessageUseCase: getIt<DeleteMessageUseCase>(),
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      seenMessageUpdateUseCase: getIt<SeenMessageUpdateUseCase>()
  ));

  //story cubit
  getIt.registerFactory<StoryCubit>(() => StoryCubit(
      createStoryUseCase: getIt<CreateStoryUseCase>(),
      deleteStoryUseCase: getIt<DeleteStoryUseCase>(),
      getStoryUseCase: getIt<GetStoryUseCase>(),
      updateStoryUseCase: getIt<UpdateStoryUseCase>(),
      updateOnlyImageStoryUseCase: getIt<UpdateOnlyImageStoryUseCase>(),
      seenStoryUpdateUseCase: getIt<SeenStoryUpdateUseCase>()
  ));

  getIt.registerFactory<MyStoryCubit>(
          () => MyStoryCubit(getMyStoryUseCase: getIt<GetMyStoryUseCase>()
  ));




  //usecase user
  getIt.registerLazySingleton<CreateUserUseCase>(
          () => CreateUserUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
  getIt.registerLazySingleton<FollowUnFollowUserUseCase>(
          () => FollowUnFollowUserUseCase(userFirebaseRepo: getIt<UserFirebaseRepo>()));
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


  //usecase real
  getIt.registerLazySingleton<CreateRealUseCase>(
          () => CreateRealUseCase(realFirebaseRepo: getIt<RealFirebaseRepo>()));
  getIt.registerLazySingleton<DeleteRealUseCase>(
          () => DeleteRealUseCase(realFirebaseRepo: getIt<RealFirebaseRepo>()));
  getIt.registerLazySingleton<LikeRealUseCase>(
          () => LikeRealUseCase(realFirebaseRepo: getIt<RealFirebaseRepo>()));
  getIt.registerLazySingleton<ReadRealsUseCase>(
          () => ReadRealsUseCase(realFirebaseRepo: getIt<RealFirebaseRepo>()));
  getIt.registerLazySingleton<ReadSingleRealUseCase>(
          () => ReadSingleRealUseCase(realFirebaseRepo: getIt<RealFirebaseRepo>()));
  getIt.registerLazySingleton<UpdateRealUseCase>(
          () => UpdateRealUseCase(realFirebaseRepo: getIt<RealFirebaseRepo>()));
  getIt.registerLazySingleton<SaveRealUseCase>(
          () => SaveRealUseCase(realFirebaseRepo: getIt<RealFirebaseRepo>()));


  //usecase comment
  getIt.registerLazySingleton<CreateCommentUseCase>(
          () => CreateCommentUseCase(commentFirebaseRepo: getIt<CommentFirebaseRepo>()));
  getIt.registerLazySingleton<DeleteCommentUseCase>(
          () => DeleteCommentUseCase(commentFirebaseRepo: getIt<CommentFirebaseRepo>()));
  getIt.registerLazySingleton<LikeCommentUseCase>(
          () => LikeCommentUseCase(commentFirebaseRepo: getIt<CommentFirebaseRepo>()));
  getIt.registerLazySingleton<ReadCommentsUseCase>(
          () => ReadCommentsUseCase(commentFirebaseRepo: getIt<CommentFirebaseRepo>()));
  getIt.registerLazySingleton<UpdateCommentUseCase>(
          () => UpdateCommentUseCase(commentFirebaseRepo: getIt<CommentFirebaseRepo>()));

  // usecase replay
  getIt.registerLazySingleton<CreateReplayUseCase>(
          () => CreateReplayUseCase(replayFirebaseRepo: getIt<ReplayFirebaseRepo>()));
  getIt.registerLazySingleton<DeleteReplayUseCase>(
          () => DeleteReplayUseCase(replayFirebaseRepo: getIt<ReplayFirebaseRepo>()));
  getIt.registerLazySingleton<LikeReplayUseCase>(
          () => LikeReplayUseCase(replayFirebaseRepo: getIt<ReplayFirebaseRepo>()));
  getIt.registerLazySingleton<ReadReplaysUseCase>(
          () => ReadReplaysUseCase(replayFirebaseRepo: getIt<ReplayFirebaseRepo>()));
  getIt.registerLazySingleton<UpdateReplayUseCase>(
          () => UpdateReplayUseCase(replayFirebaseRepo: getIt<ReplayFirebaseRepo>()));

  //chat usecase
  getIt.registerLazySingleton<DeleteMessageUseCase>(
          () => DeleteMessageUseCase(chatFirebaseRepo: getIt<ChatFirebaseRepo>()));

  getIt.registerLazySingleton<DeleteChatUseCase>(
          () => DeleteChatUseCase(chatFirebaseRepo: getIt<ChatFirebaseRepo>()));

  getIt.registerLazySingleton<GetMessagesUseCase>(
          () => GetMessagesUseCase(chatFirebaseRepo: getIt<ChatFirebaseRepo>()));

  getIt.registerLazySingleton<GetMyChatUseCase>(
          () => GetMyChatUseCase(chatFirebaseRepo: getIt<ChatFirebaseRepo>()));

  getIt.registerLazySingleton<SendMessageUseCase>(
          () => SendMessageUseCase(chatFirebaseRepo: getIt<ChatFirebaseRepo>()));

  getIt.registerLazySingleton<SeenMessageUpdateUseCase>(
          () => SeenMessageUpdateUseCase(chatFirebaseRepo: getIt<ChatFirebaseRepo>()));

  //story usecase
  getIt.registerLazySingleton<CreateStoryUseCase>(
          () => CreateStoryUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));
  getIt.registerLazySingleton<DeleteStoryUseCase>(
          () => DeleteStoryUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));
  getIt.registerLazySingleton<GetMyStoryUseCase>(
          () => GetMyStoryUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));
  getIt.registerLazySingleton<GetMyStoryFutureUseCase>(
          () => GetMyStoryFutureUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));
  getIt.registerLazySingleton<GetStoryUseCase>(
          () => GetStoryUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));
  getIt.registerLazySingleton<SeenStoryUpdateUseCase>(
          () => SeenStoryUpdateUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));
  getIt.registerLazySingleton<UpdateOnlyImageStoryUseCase>(
          () => UpdateOnlyImageStoryUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));
  getIt.registerLazySingleton<UpdateStoryUseCase>(
          () => UpdateStoryUseCase(storyFirebaseRepo: getIt<StoryFirebaseRepo>()));

  //repos user
  getIt.registerLazySingleton<UserFirebaseRepo>(
          () => UserFirebaseRepoImpl(userFirebaseRepo: getIt<UserRemoteDataSourceImpl>()));
  //repos post
  getIt.registerLazySingleton<PostFirebaseRepo>(
          () => PostFirebaseRepoImpl(postFirebaseRepo: getIt<PostRemoteDataSourceImpl>()));

  //repo real
  getIt.registerLazySingleton<RealFirebaseRepo>(
          () => RealFirebaseRepoImpl(realFirebaseRepo: getIt<RealRemoteDataSourceImpl>()));

  //repos comment and replay
  getIt.registerLazySingleton<CommentFirebaseRepo>(
          () => CommentFirebaseRepoImpl(commentFirebaseRepo: getIt<CommentRemoteDataSourceImpl>()));

  getIt.registerLazySingleton<ReplayFirebaseRepo>(
          () => ReplayFirebaseRepoImpl(replayFirebaseRepo: getIt<ReplayRemoteDataSourceImpl>()));

  //repo chat
  getIt.registerLazySingleton<ChatFirebaseRepo>(
          () => ChatFirebaseRepoImpl(chatFirebaseRepo: getIt<ChatRemoteDataSourceImpl>()));

  //repo story
  getIt.registerLazySingleton<StoryFirebaseRepo>(
          () => StoryFirebaseRepoImpl(storyFirebaseRepo: getIt<StoryRemoteDataSourceImpl>()));

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
    userFirebaseRepo: getIt<UserFirebaseRepo>(),
  ));

 //remote real
  getIt.registerLazySingleton<RealRemoteDataSourceImpl>(() => RealRemoteDataSourceImpl(
    firebaseAuth: getIt<FirebaseAuth>(),
    firebaseFirestore: getIt<FirebaseFirestore>(),
    firebaseStorage: getIt<FirebaseStorage>(),
    userFirebaseRepo: getIt<UserFirebaseRepo>(),
  ));

  //remote comment and replay
  getIt.registerLazySingleton<CommentRemoteDataSourceImpl>(() => CommentRemoteDataSourceImpl(
    firebaseFirestore: getIt<FirebaseFirestore>(),
    userFirebaseRepo: getIt<UserFirebaseRepo>(),
  ));

  getIt.registerLazySingleton<ReplayRemoteDataSourceImpl>(() => ReplayRemoteDataSourceImpl(
    firebaseFirestore: getIt<FirebaseFirestore>(),
    userFirebaseRepo: getIt<UserFirebaseRepo>(),
  ));

  //remote chat
  getIt.registerLazySingleton<ChatRemoteDataSourceImpl>(() => ChatRemoteDataSourceImpl(
    firebaseFirestore:getIt<FirebaseFirestore>(),
  ));

  //remote story
  getIt.registerLazySingleton<StoryRemoteDataSourceImpl>(() => StoryRemoteDataSourceImpl(
    firebaseFirestore:getIt<FirebaseFirestore>(),
  ));

  getIt.registerLazySingleton<FirebaseAuth>(() => authe);
  getIt.registerLazySingleton<FirebaseFirestore>(() => firestore);
  getIt.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);

}
