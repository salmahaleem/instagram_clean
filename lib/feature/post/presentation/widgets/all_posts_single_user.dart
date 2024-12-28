import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_other_single_user/get_other_single_user_cubit.dart';


class AllPostsSingleUser extends StatefulWidget {


  const AllPostsSingleUser({super.key,});
  @override
  State<AllPostsSingleUser> createState() => _AllPostsSingleUserState();
}

class _AllPostsSingleUserState extends State<AllPostsSingleUser> {
  String _currentUid = "";

  @override
  void initState() {

    super.initState();
    _initializeData();
   //  BlocProvider.of<GetOtherSingleUserCubit>(context)..getSingleOtherUser(otherUid: Constant.otherUserId);
   //  BlocProvider.of<PostCubit>(context)..getAllPosts(post: PostEntity());
   //  super.initState();
   //
   // di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
   //    setState(() {
   //      _currentUid = value;
   //    });
   //  });
  }

  Future<void> _initializeData() async {
    _currentUid = await di.getIt<GetCurrentUserIdUseCase>().call();
    setState(() {});

    // BlocProvider.of<GetOtherSingleUserCubit>(context)
    //   ..getSingleOtherUser(otherUid: Constant.otherUserId);
    //
    // BlocProvider.of<PostCubit>(context)..getAllPosts(post: PostEntity());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOtherSingleUserCubit, GetOtherSingleUserState>(
      builder: (context, state) {
        if(state is GetOtherSingleUserLoaded){
        return BlocBuilder<PostCubit, PostState>(
          builder: (context, postState) {
            if (postState is PostLoaded) {
              final posts = postState.posts.where((post) =>
              post.creatorUid == Constant.otherUserId
              ).toList();
              return GridView.builder(
                  itemCount: posts.length,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        context.go('/postDetails');
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: UserPhoto(imageUrl: posts[index].postImageUrl),
                      ),
                    );
                  });
            }
             return const Center(
              child: Text('No posts available'),
            );
          },
        );
      }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
}