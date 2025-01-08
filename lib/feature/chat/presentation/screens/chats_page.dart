import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/utils/colors.dart';
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/core/widgets/userPhoto.dart';
import 'package:instagram_clean/feature/chat/domain/entity/chat_entity.dart';
import 'package:instagram_clean/feature/chat/domain/entity/message_entity.dart';
import 'package:instagram_clean/feature/chat/presentation/cubit/chat/chat_cubit.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/single_chat_page.dart';
import 'package:instagram_clean/feature/chat/presentation/screens/user_page.dart';
import 'package:instagram_clean/feature/home/presentation/widgets/chats_widget.dart';

class ChatsPage extends StatefulWidget {
  final String uid;
   ChatsPage({super.key, required this.uid});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).getMyChat(chat: ChatEntity(senderUid: widget.uid));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:FloatingActionButton(
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactsPage(uid: widget.uid)));
      },
        child: Icon(Icons.contact_page_outlined),
        backgroundColor: AppColors.buttonColor,
      ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if(state is ChatLoaded) {
              final myChat = state.chats;
              if(myChat.isEmpty) {
                return Center(child: Text("No Conversation Yet"));
              }
              return ListView.builder(itemCount: myChat.length, itemBuilder: (context, index) {
                final chat = myChat[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleChatPage(message: MessageEntity(
                        senderUid: chat.senderUid,
                        recipientUid:chat.recipientUid,
                        senderName: chat.senderName,
                        recipientName: chat.recipientName,
                        senderProfile: chat.senderProfile,
                        recipientProfile: chat.recipientProfile,
                        uid: widget.uid
                    ))));
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: UserPhoto(),
                      ),
                    ),
                    title: Text("${chat.recipientName}"),
                    subtitle: Text("${chat.recentTextMessage}", maxLines: 1, overflow: TextOverflow.ellipsis,),
                    trailing: Text(
                      DateFormat.jm().format(chat.createdAt!.toDate()),
                      style: Theme.of(context).textTheme.titleSmall
                    ),
                  ),
                );
              });

            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
}