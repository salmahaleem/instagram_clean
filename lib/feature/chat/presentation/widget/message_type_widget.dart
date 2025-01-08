import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_aduio_widget.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_video_widget.dart';

class MessageTypeWidget extends StatelessWidget {
  final String? type;
  final String? message;
  const MessageTypeWidget({Key? key, this.type, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(type == MessageTypeConst.textMessage) {
      return Text(
        "$message",
        style: Theme.of(context).textTheme.titleMedium
      );
    } else if (type == MessageTypeConst.photoMessage) {
      return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: UserPhoto(
            imageUrl: message
        ),
      );
    } else if (type == MessageTypeConst.videoMessage) {
      return Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: CachedVideoMessageWidget(url: message!));
    } else if (type == MessageTypeConst.gifMessage) {
      return Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: CachedNetworkImage(imageUrl: message!,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),),
      );
    } else if (type == MessageTypeConst.audioMessage) {
      return MessageAudioWidget(audioUrl: message,);
    } else {
      return Text(
        "$message", maxLines: 2,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(overflow: TextOverflow.ellipsis),
      );
    }
  }
}