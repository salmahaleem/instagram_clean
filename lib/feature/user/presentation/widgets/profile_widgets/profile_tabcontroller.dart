import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/real/domain/entity/real_entity.dart';
import 'package:instagram_clean/feature/real/presentation/cubit/real_cubit.dart';
import 'package:instagram_clean/feature/real/presentation/widget/single_real_widget.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';


class ProfileTabController extends StatefulWidget {
  final UserEntity userEntity;

  const ProfileTabController({super.key, required this.userEntity});
  @override
  State<ProfileTabController> createState() => _ProfileTabControllerState();
}

class _ProfileTabControllerState extends State<ProfileTabController> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostCubit>(context).getAllPosts(post: PostEntity());
    BlocProvider.of<RealCubit>(context).getAllReals(real: RealEntity());

  }

  Widget _buildPostGrid(List<PostEntity> posts) {
    return GridView.builder(
      itemCount: posts.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.go('/postDetailsPage/:${Constant.postId}');
          },
          child: Container(
            width: 100,
            height: 100,
            child: UserPhoto(imageUrl: posts[index].postImageUrl),
          ),
        );
      },
    );
  }
  Widget _buildRealGrid(List<RealEntity> reals) {

    return GridView.builder(
      itemCount: reals.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap:() => SingleRealWidget(real: reals[index]),
          child: Container(
            width: 300,
            height: 350,
            child: SingleRealWidget(real: reals[index])
        ));
  });}

  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Theme.of(context).iconTheme.color,
              indicatorColor: Theme.of(context).iconTheme.color,
              tabs: [
                Icon(Icons.grid_on),
                Icon(Icons.video_collection_outlined),
                Icon(Icons.person),
              ],
            ),
          ),
            Container(
              height: 400.h,
              width: double.maxFinite,
              child: TabBarView(
              children: [
                Container(
                    child: BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          final posts = postState.posts
                              .where((post) => post.creatorUid == widget.userEntity.uid)
                              .toList();
                          return _buildPostGrid(posts);
                        }
                        if (postState is PostFailure) {
                          return Center(child: Text('Failed to load posts'));
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    )
                ),
                Container(
                    child: BlocBuilder<RealCubit, RealState>(
                      builder: (context, realState) {
                        if(realState is RealLoading){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if (realState is RealLoaded) {
                          final reals = realState.reals
                              .where((real) => real.creatorUid == widget.userEntity.uid)
                              .toList();
                          return _buildRealGrid(reals);
                        }
                        if (realState is RealFailure) {
                          return Center(child: Text('Failed to load posts'));
                        }
                        return const Center(child: Text("error on get reals"),);
                      },
                    )
                ),
                Container()    
              ],
                        ),
            ),
        ]),
    );
  }
}
