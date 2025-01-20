import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/utils/spacing.dart';
import 'package:instagram_clean/core/widgets/show_video_picker.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_replay_entity.dart';
import 'package:instagram_clean/feature/chat/presentation/cubit/message/message_cubit.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/chat_utils.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/dialog_widget.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_replay_preview_widget.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_replay_type_widget.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_type_widget.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/show_image_picker.dart';
import 'package:instagram_clean/feature/story/presentation/widget/storage_story.dart';
import 'package:instagram_clean/feature/user/presentation/cubit/profile_cubit/get_single_user_cubit/get_single_user_cubit.dart';
import 'package:instagram_clean/generated/locale_keys.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_to/swipe_to.dart';


class SingleChatPage extends StatefulWidget {
  final MessageEntity message;
  const SingleChatPage({super.key, required this.message});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {


  bool isShowEmojiKeyboard = false;
  FocusNode focusNode = FocusNode();

  void _hideEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = false;
    });
  }

  void _showEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = true;
    });
  }

  void _showKeyboard() => focusNode.requestFocus();
  void _hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiKeyboard) {
      _showKeyboard();
      _hideEmojiContainer();
    } else {
      _hideKeyboard();
      _showEmojiContainer();
    }
  }


  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController  = ScrollController();

  bool _isDisplaySendButton = false;
  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  bool _isShowAttachWindow = false;

  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;
  bool _isRecordInit = false;


  @override
  void initState() {
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.message.recipientUid!);

    BlocProvider.of<MessageCubit>(context).getMessages(message: MessageEntity(
        senderUid: widget.message.senderUid,
        recipientUid: widget.message.recipientUid
    ));

    super.initState();
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  Future<void> _openAudioRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    _isRecordInit = true;
  }

  File? _image;

  Future selectImage() async {
    setState(() => _image = null);
    try {
      final pickedFile =
      await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  File? _video;

  Future selectVideo() async {
    setState(() => _image = null);
    try {
      final pickedFile =
      await ImagePicker.platform.pickVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _video = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  void onMessageSwipe(
      {String? message, String? username, String? type, bool? isMe}) {
    BlocProvider.of<MessageCubit>(context).setMessageReplay =
        MessageReplayEntity(
            message: message,
            username: username,
            messageType: type,
            isMe: isMe
        );
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    final provider = BlocProvider.of<MessageCubit>(context);

    bool _isReplying = provider.messageReplay.message != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        ? Text(
                            "${LocaleKeys.chat_online.tr()}",
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w400),
                          )
                        : Container(
                            child: Text("${LocaleKeys.chat_offline.tr()}",
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
          GestureDetector(
            onTap: () {
            },
            child: const Icon(
              Icons.videocam_rounded,
              size: 25,
            ),
          ),
          horizontalSpace(25.w),
          const Icon(
            Icons.call,
            size: 22,
          ),
          horizontalSpace(25.w),
        ],
      ),
      body: BlocBuilder<MessageCubit, MessageState>(
        builder: (context, state) {
          if (state is MessageLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            final messages = state.messages;
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
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message= messages[index];
                            if(message.isSeen == false  && message.recipientUid == widget.message.uid) {
                              provider.seenMessage(message: MessageEntity(
                                  senderUid: widget.message.senderUid,
                                  recipientUid: widget.message.recipientUid,
                                  messageId: message.messageId
                              ));
                            }

                            if(message.senderUid == widget.message.senderUid) {
                              return _messageLayout(
                                messageType: message.messageType,
                                message: message.message,
                                alignment: Alignment.centerRight,
                                createAt: message.createdAt,
                                isSeen: message.isSeen,
                                isShowTick: true,
                                messageBgColor: AppColors.buttonColor,
                                rightPadding: message.repliedMessage == "" ? 85 : 5,
                                reply: MessageReplayEntity(
                                    message: message.repliedMessage,
                                    messageType: message.repliedMessageType,
                                    username: message.repliedTo
                                ),
                                onLongPress: () {
                                  focusNode.unfocus();
                                  displayAlertDialog(
                                      context,
                                      onTap: () {
                                        BlocProvider.of<MessageCubit>(context).deleteMessage(message: MessageEntity(
                                            senderUid: widget.message.senderUid,
                                            recipientUid: widget.message.recipientUid,
                                            messageId: message.messageId
                                        ));
                                        Navigator.pop(context);
                                      },
                                      confirmTitle: "Delete",
                                      content: "Are you sure you want to delete this message?"
                                  );
                                },
                                onSwipe: () {
                                  onMessageSwipe(
                                      message: message.message,
                                      username: message.senderName,
                                      type: message.messageType,
                                      isMe: true
                                  );

                                  setState(() {});
                                },
                              );
                            } else {
                              return _messageLayout(
                                messageType: message.messageType,
                                message: message.message,
                                alignment: Alignment.centerLeft,
                                createAt: message.createdAt,
                                isSeen:  message.isSeen,
                                isShowTick: false,
                                messageBgColor: Colors.white10,
                                rightPadding: message.repliedMessage == "" ? 85 : 5,
                                reply: MessageReplayEntity(
                                    message: message.repliedMessage,
                                    messageType: message.repliedMessageType,
                                    username: message.repliedTo
                                ),
                                onLongPress: () {
                                  focusNode.unfocus();
                                  displayAlertDialog(
                                      context,
                                      onTap: () {
                                        BlocProvider.of<MessageCubit>(context).deleteMessage(message: MessageEntity(
                                            senderUid: widget.message.senderUid,
                                            recipientUid: widget.message.recipientUid,
                                            messageId: message.messageId
                                        ));
                                        Navigator.pop(context);
                                      },
                                      confirmTitle: "Delete",
                                      content: "Are you sure you want to delete this message?"
                                  );
                                },
                                onSwipe: () {
                                  onMessageSwipe(
                                      message: message.message,
                                      username: message.senderName,
                                      type: message.messageType,
                                      isMe: false
                                  );

                                  setState(() {});
                                },
                              );
                            }
                          },
                        ),
                      ),



                      _isReplying == true
                          ? verticalSpace(5.h)
                          : verticalSpace(0.h),

                      _isReplying == true
                          ? Row(
                        children: [
                          Expanded(
                            child: MessageReplayPreviewWidget(
                              onCancelReplayListener: () {
                                provider.setMessageReplay =
                                    MessageReplayEntity();
                                setState(() {});
                              },
                            ),
                          ),
                          Container(
                            width: 60,
                          ),
                        ],
                      )
                          : Container(),

                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: _isReplying == true ? 0 : 5, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(color: Colors.white10, borderRadius: _isReplying == true
                                    ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(25),
                                    bottomRight:
                                    Radius.circular(25))
                                    : BorderRadius.circular(25)),
                                height: 50,
                                child: TextField(
                                  focusNode: focusNode,
                                  onTap: () {
                                    setState(() {
                                      _isShowAttachWindow = false;
                                      isShowEmojiKeyboard = false;
                                    });
                                  },
                                  controller: _textMessageController,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        _textMessageController.text = value;
                                        _isDisplaySendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        _isDisplaySendButton = false;
                                        _textMessageController.text = value;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                    prefixIcon: GestureDetector(
                                      onTap: toggleEmojiKeyboard,
                                      child: Icon(
                                          isShowEmojiKeyboard == false
                                              ? Icons.emoji_emotions
                                              : Icons.keyboard_outlined,
                                          color: Colors.grey),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Wrap(
                                        children: [
                                          Transform.rotate(
                                            angle: -0.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isShowAttachWindow = !_isShowAttachWindow;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.attach_file,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          horizontalSpace(15.w),
                                          GestureDetector(
                                            onTap: () {
                                              selectImage().then((value) {
                                                if (_image != null) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                        (timeStamp) {
                                                      showImagePickedBottomModalSheet(
                                                          context,
                                                          recipientName: widget
                                                              .message
                                                              .recipientName,
                                                          file: _image,
                                                          onTap: () {
                                                            _sendImageMessage();
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                    },
                                                  );
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          horizontalSpace(10.w),
                                        ],
                                      ),
                                    ),
                                    hintText: 'Message',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpace(10.w),
                            GestureDetector(
                              onTap: () {
                                _sendTextMessage();
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: AppColors.buttonColor),
                                child: Center(
                                  child: Icon(
                                    _isDisplaySendButton || _textMessageController.text.isNotEmpty ? Icons.send_outlined : _isRecording ? Icons.close : Icons.mic,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      isShowEmojiKeyboard
                          ? SizedBox(
                        height: 310,
                        child: Stack(
                          children: [
                            EmojiPicker(
                              config:
                              const Config(),
                              onEmojiSelected: ((category, emoji) {
                                setState(() {
                                  _textMessageController.text =
                                      _textMessageController.text +
                                          emoji.emoji;
                                });
                              }),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                height: 40,
                                decoration:
                                const BoxDecoration(color: Colors.white10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        size: 20,
                                        color: Colors.white10,
                                      ),
                                       Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .emoji_emotions_outlined,
                                            size: 20,
                                            color: Colors.white10,
                                          ),
                                          horizontalSpace(15.w),
                                          Icon(
                                            Icons.gif_box_outlined,
                                            size: 20,
                                            color: Colors.white10,
                                          ),
                                          horizontalSpace(15.w),
                                          Icon(
                                            Icons.ad_units,
                                            size: 20,
                                            color: Colors.white10,
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _textMessageController
                                                  .text =
                                                  _textMessageController
                                                      .text
                                                      .substring(
                                                      0,
                                                      _textMessageController
                                                          .text
                                                          .length - 2);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.backspace_outlined,
                                            size: 20,
                                            color: Colors.white10,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                          : const SizedBox(),
                    ],
                  ),
                  _isShowAttachWindow == true
                      ? Positioned(
                    bottom: 65,
                    top: 320,
                    left: 15,
                    right: 15,
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.20,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _attachWindowItem(
                                icon: Icons.document_scanner,
                                color: Colors.deepPurpleAccent,
                                title: "Document",
                              ),
                              _attachWindowItem(
                                  icon: Icons.camera_alt,
                                  color: Colors.pinkAccent,
                                  title: "Camera",
                                  onTap: () {}),
                              _attachWindowItem(icon: Icons.image, color: Colors.purpleAccent, title: "Gallery"),
                            ],
                          ),
                          verticalSpace(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _attachWindowItem(icon: Icons.headphones, color: Colors.deepOrange, title: "Audio"),
                              _attachWindowItem(icon: Icons.location_on, color: Colors.green, title: "Location"),
                              _attachWindowItem(
                                  icon: Icons.account_circle, color: Colors.deepPurpleAccent, title: "Contact"),
                            ],
                          ),
                          verticalSpace(20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _attachWindowItem(
                                icon: Icons.bar_chart,
                                color: Colors.blue,
                                title: "Poll",
                              ),
                              _attachWindowItem(
                                  icon: Icons.gif_box_outlined,
                                  color: Colors.indigoAccent,
                                  title: "Gif",
                                  onTap: () {
                                  }),
                              _attachWindowItem(
                                  icon: Icons.videocam_rounded,
                                  color: Colors.lightGreen,
                                  title: "Video",
                                  onTap: () {

                                    selectVideo().then((value) {
                                      if (_video != null) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                              (timeStamp) {
                                            showVideoPickedBottomModalSheet(
                                                context,
                                                recipientName: widget.message.recipientName,
                                                file: _video,
                                                onTap: () {
                                                  _sendVideoMessage();
                                                  Navigator.pop(context);
                                                });
                                          },
                                        );
                                      }
                                    });

                                    setState(() {
                                      _isShowAttachWindow = false;
                                    });
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white10,
            ),
          );
        },
      ),
    );
  }

  _messageLayout({
    Color? messageBgColor,
    Alignment? alignment,
    Timestamp? createAt,
    VoidCallback? onSwipe,
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
        //onRightSwipe: onSwipe,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            alignment: alignment,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 5, right: messageType == MessageTypeConst.textMessage ? rightPadding! : 5, top: 5, bottom: 5),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.80),
                        decoration: BoxDecoration(color: messageBgColor, borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            reply?.message == null || reply?.message == ""
                                ? const SizedBox() :Container(
                              height: reply!.messageType ==
                                  MessageTypeConst.textMessage ? 70 : 80,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: 4.5,
                                    decoration: BoxDecoration(
                                        color: reply.username == widget.message.recipientName ? Colors.deepPurpleAccent
                                            : Colors.white10,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
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
                                                fontWeight: FontWeight.bold,
                                                color: reply.username == widget.message.recipientName
                                                    ? Colors.deepPurpleAccent
                                                    : Colors.white10
                                            ),
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
                        )
                    ),
                    verticalSpace(3.h),
                  ],
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(createAt!.toDate()),
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      horizontalSpace(5.w),
                      isShowTick == true
                          ? Icon(
                        isSeen == true ? Icons.done_all : Icons.done,
                        size: 16,
                        color: isSeen == true ? Colors.blue : Colors.grey,
                      )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _attachWindowItem({IconData? icon, Color? color, String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: color),
            child: Icon(icon),
          ),
          verticalSpace(5.h),
          Text(
            "$title",
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }


  _sendTextMessage() async {
    final provider = BlocProvider.of<MessageCubit>(context);

    if(_isDisplaySendButton || _textMessageController.text.isNotEmpty) {
      if(provider.messageReplay.message != null) {

        _sendMessage(
            message: _textMessageController.text,
            type: MessageTypeConst.textMessage,
            repliedMessage: provider.messageReplay.message,
            repliedTo: provider.messageReplay.username,
            repliedMessageType: provider.messageReplay.messageType
        );

      } else {
        _sendMessage(
            message: _textMessageController.text,
            type: MessageTypeConst.textMessage
        );
      }

      provider.setMessageReplay = MessageReplayEntity();
      setState(() {
        _textMessageController.clear();
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

  void _sendImageMessage() {
    InstagramStorage.uploadMessageFile(
      file: _image!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.photoMessage,
    ).then((photoImageUrl) {
      _sendMessage(message: photoImageUrl, type: MessageTypeConst.photoMessage);
    });
  }

  void _sendVideoMessage() {
    InstagramStorage.uploadMessageFile(
      file: _video!,
      onComplete: (value) {},
      uid: widget.message.senderUid,
      otherUid: widget.message.recipientUid,
      type: MessageTypeConst.videoMessage,
    ).then((videoUrl) {
      _sendMessage(message: videoUrl, type: MessageTypeConst.videoMessage);
    });
  }


  void _sendMessage({required String message,
    required String type,
    String? repliedMessage,
    String? repliedTo,
    String? repliedMessageType}) {

    _scrollToBottom();

    ChatUtils.sendMessage(context,
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

}


