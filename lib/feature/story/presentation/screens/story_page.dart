import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/home/presentation/screens/home_page.dart';
import 'package:instagram_clean/feature/story/domain/usecase/get_my_story_future.dart';
import 'package:instagram_clean/feature/story/presentation/cubit/my_story/my_story_cubit.dart';
import 'package:instagram_clean/feature/story/presentation/cubit/stories/story_cubit.dart';
import 'package:instagram_clean/feature/story/presentation/widget/show_image_and_video_widget.dart';
import 'package:instagram_clean/feature/story/presentation/widget/storage_story.dart';
import 'package:instagram_clean/feature/story/presentation/widget/story_dotted_border_widget.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import '../../domain/entity/story_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class StoryPage extends StatefulWidget {
  final UserEntity currentUser;

  const StoryPage({super.key, required this.currentUser});
  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<StoryImageEntity> _stories = [];
  List<StoryItem> myStories = [];
  List<File>? _selectedMedia;
  List<String>? _mediaTypes;

  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();
        // Initialize the media types list
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');
        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }
        setState(() {});
        print("mediaTypes = $_mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<StoryCubit>(context).getStory(story: StoryEntity());
    BlocProvider.of<MyStoryCubit>(context)
        .getMyStory(uid: widget.currentUser.uid!);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      di
          .getIt<GetMyStoryFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty && myStatus.first.stories != null) {
          _fillMyStoriesList(myStatus.first);
        }
      });
    });
  }

  Future _fillMyStoriesList(StoryEntity story) async {
    if (story.stories != null) {
      _stories = story.stories!;
      for (StoryImageEntity story in story.stories!) {
        myStories.add(StoryItem(
            url: story.url!,
            type: StoryItemTypeExtension.fromString(story.type!),
            viewers: story.viewers!));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryCubit, StoryState>(
      builder: (context, stateStory) {
        if (stateStory is StoryLoaded) {
          final Storys = stateStory.Storys.where(
              (element) => element.uid != widget.currentUser.uid).toList();
          print("Storys loaded $Storys");
          return BlocBuilder<MyStoryCubit, MyStoryState>(
            builder: (context, state) {
              if (state is MyStoryLoaded) {
                print("loaded my story ${state.myStory}");
                return _bodyWidget(Storys, widget.currentUser,
                    myStories: state.myStory);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _bodyWidget(List<StoryEntity> storys, UserEntity currentUser,
      {StoryEntity? myStories}) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    myStories != null
                        ? GestureDetector(
                            onTap: () {
                              _eitherShowOrUploadSheet(myStories, currentUser);
                            },
                            child: Container(
                              width: 55,
                              height: 55,
                              margin: const EdgeInsets.all(12.5),
                              child: CustomPaint(
                                painter: StoryDottedBordersWidget(
                                    isMe: true,
                                    numberOfStories: myStories.stories!.length,
                                    spaceLength: 4,
                                    images: myStories.stories!,
                                    uid: widget.currentUser.uid),
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  width: 55,
                                  height: 55,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child:
                                        UserPhoto(imageUrl: myStories.imageUrl),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: 60,
                            height: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child:
                                  UserPhoto(imageUrl: currentUser.profileUrl),
                            ),
                          ),
                    myStories != null
                        ? Container()
                        : Positioned(
                            right: 10,
                            bottom: 8,
                            child: GestureDetector(
                              onTap: () {
                                _eitherShowOrUploadSheet(
                                    myStories, currentUser);
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: AppColors.buttonColor,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 2, color: Colors.white)),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
                //Text("My Story"),
              ],
            ),
            horizontalSpace(5),
            Container(
              width: double.maxFinite,
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: storys.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final story = storys[index];
                    List<StoryItem> stories = [];
                    for (StoryImageEntity storyItem in story.stories!) {
                      stories.add(StoryItem(
                          url: storyItem.url!,
                          viewers: storyItem.viewers,
                          type: StoryItemTypeExtension.fromString(
                              storyItem.type!)));
                    }
                    return ListTile(
                      onTap: () {
                        _showStoryImageViewBottomModalSheet(
                            story: story, stories: stories);
                      },
                      leading: SizedBox(
                        width: 55,
                        height: 55,
                        child: CustomPaint(
                          painter: StoryDottedBordersWidget(
                              isMe: false,
                              numberOfStories: story.stories!.length,
                              spaceLength: 4,
                              images: story.stories,
                              uid: widget.currentUser.uid),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            width: 55,
                            height: 55,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: UserPhoto(imageUrl: story.imageUrl),
                            ),
                          ),
                        ),
                      ),
                      //subtitle:  Text("${story.username}"),
                      //titleAlignment: ListTileTitleAlignment.bottom,
                    );
                  }),
            )
          ],
        ),
      ),
    ));
  }

  void _eitherShowOrUploadSheet(StoryEntity? myStory, UserEntity currentUser) {
    if (myStory != null) {
      _showStoryImageViewBottomModalSheet(story: myStory, stories: myStories);
    } else {
      selectMedia().then(
        (value) {
          if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return ShowMultiImageAndVideoPickedWidget(
                  selectedFiles: _selectedMedia!,
                  onTap: () {
                    _uploadImageStory(currentUser);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  _uploadImageStory(UserEntity currentUser) {
    InstagramStorage.uploadStories(
            files: _selectedMedia!, onComplete: (onCompleteStoryUpload) {})
        .then((storyImageUrls) {
      for (var i = 0; i < storyImageUrls.length; i++) {
        _stories.add(StoryImageEntity(
          url: storyImageUrls[i],
          type: _mediaTypes![i],
          viewers: const [],
        ));
      }

      di
          .getIt<GetMyStoryFutureUseCase>()
          .call(widget.currentUser.uid!)
          .then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StoryCubit>(context)
              .updateOnlyImageStory(
                  story: StoryEntity(
                      storyId: myStatus.first.storyId, stories: _stories))
              .then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePage(
                          userEntity: widget.currentUser,
                          //index: 1,
                        )));
          });
        } else {
          BlocProvider.of<StoryCubit>(context)
              .createStory(
            story: StoryEntity(
              description: "",
              createdAt: Timestamp.now(),
              stories: _stories,
              username: currentUser.username,
              uid: currentUser.uid,
              profileUrl: currentUser.profileUrl,
              imageUrl: storyImageUrls[0],
            ),
          )
              .then((value) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => HomePage(
                          userEntity: widget.currentUser,
                          //index: 1,
                        )));
          });
        }
      });
    });
  }

  Future _showStoryImageViewBottomModalSheet(
      {StoryEntity? story, required List<StoryItem> stories}) async {
    print("storieas $stories");
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return FlutterStoryView(
          onComplete: () {
            Navigator.pop(context);
          },
          storyItems: stories,
          enableOnHoldHide: false,
          onPageChanged: (index) {
            BlocProvider.of<StoryCubit>(context).seenStoryUpdate(
                imageIndex: index,
                userId: widget.currentUser.uid!,
                storyId: story.storyId!);
          },
          createdAt: story!.createdAt!.toDate(),
        );
      },
    );
  }
}
