import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/home/presentation/screens/home_page.dart';
import 'package:instagram_clean/feature/story/domain/entity/story_entity.dart';
import 'package:instagram_clean/feature/story/presentation/cubit/stories/story_cubit.dart';
import 'package:instagram_clean/feature/story/presentation/widget/delete_story_update_widget.dart';
import 'package:instagram_clean/generated/locale_keys.dart';

class MyStoryPage extends StatefulWidget {
  final StoryEntity story;

  const MyStoryPage({super.key, required this.story});

  @override
  State<MyStoryPage> createState() => _MyStoryPageState();
}

class _MyStoryPageState extends State<MyStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: UserPhoto(
                          imageUrl: widget.story.imageUrl
                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Text(
                      GetTimeAgo.parse(widget.story.createdAt!.toDate().subtract(Duration(seconds: DateTime.now().second))),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white10)
                    ),
                  ),

                   GestureDetector(onTap: ()=>_openBottomModalSheet(context),
                          child: Icon(Icons.more_vert,),),
                    ],
                  )
                ],
              )
          ),
      ),
    );
  }

  _openBottomModalSheet(BuildContext context,) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: Colors.black.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: (){
                          deleteStoryUpdate(context, onTap: () {
                            Navigator.pop(context);
                            BlocProvider.of<StoryCubit>(context).deleteStory(
                                story: StoryEntity(
                                    storyId: widget.story.storyId
                                )
                            );
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage(currentUser: Constant.userEntity,)));
                          });
                        },
                        child: Text("${LocaleKeys.post_delete_story.tr()}",
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  }
