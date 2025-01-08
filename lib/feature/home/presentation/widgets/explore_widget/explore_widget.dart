import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/comment%20and%20replay/presentation/widget/single_replay_widget.dart';
import 'package:instagram_clean/feature/home/presentation/widgets/explore_widget/search_widget.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/post/presentation/screens/post_details_page.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/real_cubit.dart';
import 'package:instagram_clean/feature/real/presentation/widget/single_real_widget.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:instagram_clean/feature/user/presentation/screens/single_user_profile_page.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).getAllUsers(user: UserEntity());
    BlocProvider.of<PostCubit>(context).getAllPosts(post: PostEntity());
    BlocProvider.of<RealCubit>(context).getAllReals(real: RealEntity());
    _searchController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, userState) {
            if (userState is ProfileLoaded) {
              final filterAllUsers = userState.users.where((user) =>
              user.username!.startsWith(_searchController.text) ||
                  user.username!.toLowerCase().startsWith(_searchController.text.toLowerCase()) ||
                  user.username!.contains(_searchController.text) ||
                  user.username!.toLowerCase().contains(_searchController.text.toLowerCase())
              ).toList();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWidget(
                      controller: _searchController,
                    ),
                    verticalSpace(10.h),
                    _searchController.text.isNotEmpty ? Expanded(
                      child: ListView.builder(
                          itemCount: filterAllUsers.length,
                          itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                             //final String otherUserId= "${filterAllUsers[index].uid}";
                            //context.go('/singleUserPage/:${filterAllUsers[index].uid}'),
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleUserProfilePage(otherUserId: '${filterAllUsers[index].uid}',)));},
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: UserPhoto(imageUrl: filterAllUsers[index].profileUrl),
                                ),
                              ),
                              horizontalSpace(10.w),
                              Text("${filterAllUsers[index].username}", style: Theme.of(context).textTheme.titleMedium,)
                            ],
                          ),
                        );
                      }),
                    ) :BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          final posts = postState.posts;
                          return Expanded(
                            child: GridView.builder(
                                itemCount: posts.length,
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () =>
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PostDetailsPage(postId: "${posts[index].postId}",))),

                                  //context.go('/postDetailsPage/:${Constant.postId}'),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: UserPhoto(
                                          imageUrl: posts[index].postImageUrl
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                        return Center(child: CircularProgressIndicator(),);
                      },
                    ),
                BlocBuilder<RealCubit, RealState>(
              builder: (context, realState) {
                if (realState is RealLoaded) {
                  final reals = realState.reals;
                  return Expanded(
                    child: GridView.builder(
                        itemCount: reals.length,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, crossAxisSpacing: 5, mainAxisSpacing: 5),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () =>
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleRealWidget(real: reals[index]))),
                            //context.go('/postDetailsPage/:${Constant.postId}'),
                            child: Container(
                              width: 200,
                              height: 250,
                              child: SingleRealWidget(real: reals[index])
                            ),
                          );
                        }),
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              },
                )
                  ],
                ),
              );

            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}