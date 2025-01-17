
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clean/core/get_it/get_it.dart'as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/chat/data/models/chat_model.dart';
import 'package:instagram_clean/feature/chat/data/models/message_model.dart';
import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/domain/repository/chat_firebase_repo.dart';
import 'package:instagram_clean/feature/notification/domain/repo/notification_repo.dart';
import 'package:instagram_clean/feature/notification/model/notification_model.dart';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSourceImpl implements ChatFirebaseRepo {
  final FirebaseFirestore firebaseFirestore;

  ChatRemoteDataSourceImpl({required this.firebaseFirestore});


  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {

    await sendMessageBasedOnType(message);

    String recentTextMessage = "";

    switch (message.messageType) {
      case MessageTypeConst.photoMessage:
        recentTextMessage = '📷 Photo';
        break;
      case MessageTypeConst.videoMessage:
        recentTextMessage = '📸 Video';
        break;
      case MessageTypeConst.audioMessage:
        recentTextMessage = '🎵 Audio';
        break;
      case MessageTypeConst.gifMessage:
        recentTextMessage = 'GIF';
        break;
      default:
        recentTextMessage = message.message!;
    }


    await addToChat(ChatEntity(
      createdAt: chat.createdAt,
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      totalUnReadMessages: chat.totalUnReadMessages,
    ));

    di.getIt<NotificationRepo>().generateNotification(NotificationModel(
      uid:chat.senderUid,
      otherUid: chat.recipientUid,
      username: chat.senderName,
      userProfile: chat.senderProfile,
      description: recentTextMessage
    ));

  }

  Future<void> addToChat(ChatEntity chat) async {

    // users -> uid -> myChat -> uid -> messages -> messageIds

    final myChatRef = firebaseFirestore
        .collection(Constant.users)
        .doc(chat.senderUid)
        .collection(Constant.myChat);

    final otherChatRef = firebaseFirestore
        .collection(Constant.users)
        .doc(chat.recipientUid)
        .collection(Constant.myChat);

    final myNewChat = ChatModel(
      createdAt: chat.createdAt,
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: chat.recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      totalUnReadMessages: chat.totalUnReadMessages,
    ).toDocument();

    final otherNewChat = ChatModel(
        createdAt: chat.createdAt,
        senderProfile: chat.recipientProfile,
        recipientProfile: chat.senderProfile,
        recentTextMessage: chat.recentTextMessage,
        recipientName: chat.senderName,
        senderName: chat.recipientName,
        recipientUid: chat.senderUid,
        senderUid: chat.recipientUid,
        totalUnReadMessages: chat.totalUnReadMessages)
        .toDocument();

    try {
      myChatRef.doc(chat.recipientUid).get().then((myChatDoc) async {
        // Create
        if (!myChatDoc.exists) {
          await myChatRef.doc(chat.recipientUid).set(myNewChat);
          await otherChatRef.doc(chat.senderUid).set(otherNewChat);
          return;
        } else {
          // Update
          await myChatRef.doc(chat.recipientUid).update(myNewChat);
          await otherChatRef.doc(chat.senderUid).update(otherNewChat);
          return;
        }
      });
    } catch (e) {
      print("error occur while adding to chat");
    }
  }

  Future<void> sendMessageBasedOnType(MessageEntity message) async {

    // users -> uid -> myChat -> uid -> messages -> messageIds

    final myMessageRef = firebaseFirestore
        .collection(Constant.users)
        .doc(message.senderUid)
        .collection(Constant.myChat)
        .doc(message.recipientUid)
        .collection(Constant.messages);

    final otherMessageRef = firebaseFirestore
        .collection(Constant.users)
        .doc(message.recipientUid)
        .collection(Constant.myChat)
        .doc(message.senderUid)
        .collection(Constant.messages);

    String messageId = const Uuid().v1();

    final newMessage = MessageModel(
        senderUid: message.senderUid,
        recipientUid: message.recipientUid,
        senderName: message.senderName,
        recipientName: message.recipientName,
        createdAt: message.createdAt,
        repliedTo: message.repliedTo,
        repliedMessage: message.repliedMessage,
        isSeen: message.isSeen,
        messageType: message.messageType,
        message: message.message,
        messageId: messageId,
        repliedMessageType: message.repliedMessageType)
        .toDocument();

    try {
      await myMessageRef.doc(messageId).set(newMessage);
      await otherMessageRef.doc(messageId).set(newMessage);
    } catch (e) {
      print("error occur while sending message");
    }

  }


  @override
  Future<void> deleteChat(ChatEntity chat) async {
    final chatRef = firebaseFirestore
        .collection(Constant.users)
        .doc(chat.senderUid)
        .collection(Constant.myChat)
        .doc(chat.recipientUid);

    try {

      await chatRef.delete();

    } catch (e) {
      print("error occur while deleting chat conversation $e");
    }

  }

  @override
  Future<void> deleteMessage(MessageEntity message) async {
    final messageRef = firebaseFirestore
        .collection(Constant.users)
        .doc(message.senderUid)
        .collection(Constant.myChat)
        .doc(message.recipientUid)
        .collection(Constant.messages)
        .doc(message.messageId);

    try {

      await messageRef.delete();

    } catch (e) {
      print("error occur while deleting message $e");
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) {
    final messagesRef = firebaseFirestore
        .collection(Constant.users)
        .doc(message.senderUid)
        .collection(Constant.myChat)
        .doc(message.recipientUid)
        .collection(Constant.messages)
        .orderBy("createdAt", descending: false);

    return messagesRef.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => MessageModel.fromSnapshot(e)).toList());

  }

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) {
    final myChatRef = firebaseFirestore
        .collection(Constant.users)
        .doc(chat.senderUid)
        .collection(Constant.myChat)
        .orderBy("createdAt", descending: true);

    return myChatRef
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((e) => ChatModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> seenMessageUpdate(MessageEntity message) async {
    final myMessagesRef = firebaseFirestore
        .collection(Constant.users)
        .doc(message.senderUid)
        .collection(Constant.myChat)
        .doc(message.recipientUid)
        .collection(Constant.messages)
        .doc(message.messageId);

    final otherMessagesRef = firebaseFirestore
        .collection(Constant.users)
        .doc(message.recipientUid)
        .collection(Constant.myChat)
        .doc(message.senderUid)
        .collection(Constant.messages)
        .doc(message.messageId);

    await myMessagesRef.update({"isSeen": true});
    await otherMessagesRef.update({"isSeen": true});
  }




}