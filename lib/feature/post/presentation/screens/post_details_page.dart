import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/get_single_post/single_post_cubit.dart';
import 'package:instagram_clean/feature/user/domain/usecase/getCurrentUserId_usecase.dart';

class PostDetailsPage extends StatefulWidget{
  final String postId;
  const PostDetailsPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {

  String _currentUid = '';

  @override
  void initState() {
    super.initState();

    // Fetch the post
    BlocProvider.of<SinglePostCubit>(context).getSinglePost(postId: Constant.postId);

    // Get the current user ID
    di.getIt<GetCurrentUserIdUseCase>().call().then((value) {
      if (mounted) { // تحقق من أن الصفحة ما زالت موجودة
        setState(() {
          _currentUid = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(onPressed: () {
          context.go('/mainPage');
        },
        icon: Icon(Icons.arrow_back)),
        title: Text("Post Detail"),
      ),
      body: BlocBuilder<SinglePostCubit,SinglePostState>(
          builder: (context,singlePostState){
            if(singlePostState is SinglePostLoaded){
              final singlePost = singlePostState.post;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: UserPhoto(imageUrl: singlePost.postImageUrl ?? 'default_image_url'),
                  ),
                  ],
                ),
              );

            }else if(singlePostState is SinglePostFailure){
                return Center(child: Text("error in get post ...... "));
            }
            return Center(child: Text("error in get post "));
          }),
    );
  }
}
