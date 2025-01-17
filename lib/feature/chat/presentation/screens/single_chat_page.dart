import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/chat/data/data_source/chat_remote_data_source_impl.dart';

import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_replay_entity.dart';
import 'package:instagram_clean/feature/chat/presentation/cubit/message/message_cubit.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/chats_page.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/chat_utils.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_replay_type_widget.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_type_widget.dart';
import 'package:instagram_clean/feature/story/data/data_source/story_remote_data_source_impl.dart';
import 'package:instagram_clean/feature/story/presentation/widget/storage_story.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipe_to/swipe_to.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity message;
  const SingleChatPage({super.key, required this.message});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  bool _isDisplaySendButton = false;
  bool _isShowAttachWindow = false;
  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;
  bool _isRecordInit = false;

  // @override
  // void dispose() {
  //   Constant.textMessageController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MessageCubit>(context).getMessages(
        message: MessageEntity(
            senderUid: widget.message.senderUid,
            recipientUid: widget.message.recipientUid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatsPage(uid:"${widget.message.senderUid}")));
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: UserPhoto(
                  imageUrl: widget.message.recipientProfile,
                ),
              ),
            ),
            horizontalSpace(5.w),
            Column(
              children: [
                Text('${widget.message.recipientName}',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),),
                verticalSpace(5.h),
                BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
                    builder: (context, state) {
                  if (state is GetSingleUserLoaded) {
                    return state.user.isOnline == true
                        ? const Text(
                            "Online",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w400),
                          )
                        : Container(
                            child: Text("Offline",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400)));
                  }
                  return Container();
                }),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  Icons.call,
                  size: 22,
                ),
                horizontalSpace(15.w),
                Icon(
                  Icons.videocam_rounded,
                  size: 25,
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, messageState) {
          if (messageState is MessageLoaded) {
            final messages = messageState.messages;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _isShowAttachWindow = false;
                });
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      //messages
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            if (message.senderUid == widget.message.senderUid) {
                              return _messageLayout(
                                message: message.message,
                                alignment: Alignment.centerRight,
                                createAt: message.createdAt,
                                isSeen: false,
                                isShowTick: true,
                                messageBgColor: AppColors.buttonColor,
                                rightPadding: message.repliedMessage == "" ? 85 : 5,
                                onLongPress: () {},
                              );
                            } else {
                              return _messageLayout(
                                message: message.message,
                                alignment: Alignment.centerLeft,
                                createAt: message.createdAt,
                                isSeen: false,
                                isShowTick: false,
                                messageBgColor: Colors.white10,
                                rightPadding: message.repliedMessage == "" ? 85 : 5,
                                onLongPress: () {},
                              );
                            }
                          },
                        ),
                      ),
                      //chat textFielld
                      Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(25.r)),
                                height: 50,
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      _isShowAttachWindow = false;
                                    });
                                  },
                                  controller: Constant.textMessageController,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        _isDisplaySendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isDisplaySendButton = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      prefixIcon:
                                          Icon(Icons.camera_alt_outlined),
                                      suffixIcon: Wrap(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isShowAttachWindow = true;
                                                  });
                                                },
                                                child: Icon(Icons.attach_file)),
                                          ),
                                          horizontalSpace(15.w),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12.0),
                                            child: Icon(
                                                Icons.emoji_emotions_outlined),
                                          ),
                                          horizontalSpace(10.w),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _sendTextMessage();
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.r),
                                                  color: AppColors.buttonColor,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    _isDisplaySendButton
                                                        ? Icons.send
                                                        : Icons.mic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      hintText: "Message",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _isShowAttachWindow == true
                      ? Positioned(
                          bottom: 65,
                          top: 500,
                          left: 10,
                          right: 10,
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width * 0.10,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _attachWindowItem(
                                        icon: Icons.file_present_outlined,
                                        color: Colors.black,
                                        title: "Document"),
                                    horizontalSpace(25.w),
                                    _attachWindowItem(
                                        icon: Icons.image,
                                        color: Colors.black,
                                        title: "Gallery"),
                                    horizontalSpace(25.w),
                                    _attachWindowItem(
                                        icon: Icons.location_on,
                                        color: Colors.black,
                                        title: "Location"),
                                  ],
                                )
                              ],
                            ),
                          ))
                      : Container()
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _messageLayout(
      {
        Color? messageBgColor,
      Alignment? alignment,
      Timestamp? createAt,
      GestureDragUpdateCallback? onSwipe,
      String? message,
      String? messageType,
      bool? isShowTick,
      bool? isSeen,
      VoidCallback? onLongPress,
      MessageReplayEntity? reply,
      double? rightPadding
      }) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SwipeTo(
          onRightSwipe: onSwipe,
          child: GestureDetector(
            onLongPress: onLongPress,
            child: Container(
              alignment: alignment,
              child: Stack(children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(
                            left: 5,
                            right: messageType == MessageTypeConst.textMessage
                                ? rightPadding!
                                : 5,
                            top: 5,
                            bottom: 5),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.80),
                        decoration: BoxDecoration(
                            color: messageBgColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            reply?.message == null || reply?.message == ""
                                ? const SizedBox()
                                : Container(
                                    height: reply!.messageType ==
                                            MessageTypeConst.textMessage
                                        ? 70
                                        : 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: double.infinity,
                                          width: 4.5,
                                          decoration: BoxDecoration(
                                              color: reply.username ==
                                                      widget
                                                          .message.recipientName
                                                  ? Colors.deepPurpleAccent
                                                  : Colors.green,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      bottomLeft:
                                                          Radius.circular(15))),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${reply.username == widget.message.recipientName ? reply.username : "You"}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: reply.username ==
                                                              widget.message
                                                                  .recipientName
                                                          ? Colors
                                                              .deepPurpleAccent
                                                          : Colors.green),
                                                ),
                                                MessageReplayTypeWidget(
                                                  message: reply.message,
                                                  type: reply.messageType,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            verticalSpace(3.h),
                            MessageTypeWidget(
                              message: message,
                              type: messageType,
                            ),
                          ],
                        )),
                    verticalSpace(5.h)
                  ],
                ),
                Positioned(
                    bottom: 4,
                    right: 10,
                    child: Row(children: [
                      Text(DateFormat.jm().format(createAt!.toDate()),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 10)),
                      horizontalSpace(5.w),
                      isShowTick == true
                          ? Icon(
                              isSeen == true ? Icons.done_all : Icons.done,
                              size: 16,
                              color: isSeen == true ? Colors.blue : Colors.grey,
                            )
                          : Container(),
                    ]))
              ]),
            ),
          ),
        ));
  }

  _attachWindowItem(
      {IconData? icon, Color? color, String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: color),
            child: Icon(icon),
          ),
          const SizedBox(
            height: 5,
          ),
          Text("$title", style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Future<void> _scrollToBottom() async {
    if (Constant.scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      Constant.scrollController.animateTo(
        Constant.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(
      {required String message,
      required String type,
      String? repliedMessage,
      String? repliedTo,
      String? repliedMessageType}) {
    _scrollToBottom();

    ChatUtils.sendMessage(
      context,
      messageEntity: widget.message,
      message: message,
      type: type,
      repliedTo: repliedTo,
      repliedMessageType: repliedMessageType,
      repliedMessage: repliedMessage,
    ).then((value) {
      _scrollToBottom();
    });
  }

  _sendTextMessage() async {
    final provider = BlocProvider.of<MessageCubit>(context);

    if (_isDisplaySendButton ||
        Constant.textMessageController.text.isNotEmpty) {
      if (provider.messageReplay.message != null) {
        _sendMessage(
            message: Constant.textMessageController.text,
            type: MessageTypeConst.textMessage,
            repliedMessage: provider.messageReplay.message,
            repliedTo: provider.messageReplay.username,
            repliedMessageType: provider.messageReplay.messageType);
      } else {
        _sendMessage(
            message: Constant.textMessageController.text,
            type: MessageTypeConst.textMessage);
      }

      provider.setMessageReplay = MessageReplayEntity();
      setState(() {
        Constant.textMessageController.clear();
      });
    } else {
      final temporaryDir = await getTemporaryDirectory();
      final audioPath = '${temporaryDir.path}/flutter_sound.aac';
      if (!_isRecordInit) {
        return;
      }

      if (_isRecording == true) {
        await _soundRecorder!.stopRecorder();
        InstagramStorage.uploadMessageFile(
          file: File(audioPath),
          onComplete: (value) {},
          uid: widget.message.senderUid,
          otherUid: widget.message.recipientUid,
          type: MessageTypeConst.audioMessage,
        ).then((audioUrl) {
          _sendMessage(message: audioUrl, type: MessageTypeConst.audioMessage);
        });
      } else {
        await _soundRecorder!.startRecorder(
          toFile: audioPath,
        );
      }

      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }
}
