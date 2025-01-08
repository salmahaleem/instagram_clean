import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/chat/presentation/widget/message_video_widget.dart';

class MessageReplayTypeWidget extends StatelessWidget {
  final String? type;
  final String? message;
  const MessageReplayTypeWidget({Key? key, this.type, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(type == MessageTypeConst.textMessage) {
      return Text(
        "$message", maxLines: 2,
        style: const TextStyle(color: Colors.grey, fontSize: 12, overflow: TextOverflow.ellipsis),
      );
    } else if (type == MessageTypeConst.photoMessage) {
      return Row(
        children: [
          const SizedBox(width: 200,child: Text("Photo")),
          SizedBox(
            width: 50,
            height: 50,
            child: UserPhoto(
                imageUrl: message
            ),
          ),
        ],
      );
    } else if (type == MessageTypeConst.videoMessage) {
      return Row(
        children: [
          const SizedBox(width: 200,child: Text("Video")),
          SizedBox(width: 50, height: 50,child: CachedVideoMessageWidget(url: message!)),
        ],
      );
    } else if (type == MessageTypeConst.gifMessage) {
      return Row(
        children: [
          const SizedBox(width: 200,child: Text("GIF")),
          SizedBox(
            width: 50,
            height: 50,
            child: CachedNetworkImage(imageUrl: message!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),),
          ),
        ],
      );
    } else if (type == MessageTypeConst.audioMessage) {
      return const Row(
        children: [
          Icon(
            Icons.play_circle,
            size: 40,
            color: Colors.grey,
          ),
          SizedBox(width: 10,),
          SizedBox(
            width: 190,
            height: 2,
            child: LinearProgressIndicator(
              value: 0,
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      );
    } else {
      return Text(
        "$message", maxLines: 2,
        style: Theme.of(context).textTheme.titleMedium
      );
    }
  }
}