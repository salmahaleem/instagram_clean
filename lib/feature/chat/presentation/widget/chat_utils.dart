import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';

import '../cubit/message/message_cubit.dart';

class ChatUtils {

  static Future<void> sendMessage(BuildContext context, {
    required MessageEntity messageEntity,
    String? message,
    String? type,
    String? repliedMessage,
    String? repliedTo,
    String? repliedMessageType,
  }) async {
    BlocProvider.of<MessageCubit>(context).sendMessage(
      message: MessageEntity(
          senderUid: messageEntity.senderUid,
          recipientUid: messageEntity.recipientUid,
          senderName: messageEntity.senderName,
          recipientName: messageEntity.recipientName,
          messageType: type,
          repliedMessage: repliedMessage ?? "",
          repliedTo: repliedTo ?? "",
          repliedMessageType: repliedMessageType ?? "",
          isSeen: false,
          createdAt: Timestamp.now(),
          message: message
      ),
      chat: ChatEntity(
        senderUid: messageEntity.senderUid,
        recipientUid: messageEntity.recipientUid,
        senderName: messageEntity.senderName,
        recipientName: messageEntity.recipientName,
        senderProfile: messageEntity.senderProfile,
        recipientProfile: messageEntity.recipientProfile,
        createdAt: Timestamp.now(),
        totalUnReadMessages: 0,
      ),
    );
  }
}