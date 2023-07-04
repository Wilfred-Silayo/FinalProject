import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/home/widgets/custom_circular_avator.dart';
import 'package:hls_network/features/messages/widgets/bottom_chat_field.dart';
import 'package:hls_network/features/messages/widgets/chat_list.dart';
import 'package:hls_network/models/user_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static Route route(UserModel receiver) {
    return MaterialPageRoute(
      builder: (context) => ChatScreen(
        receiver: receiver,
      ),
    );
  }

  const ChatScreen({super.key, required this.receiver});

  final UserModel receiver;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: false,
        title:ListTile(
          leading:CustomCircularAvator(photoUrl: widget.receiver.profilePic,radius: 25,),
          title:Text(widget.receiver.fullName),
        ),),
       body: Column(
          children: [
            Expanded(
              child: ChatList(
                recieverUserId: widget.receiver.uid,
              ),
            ),
            BottomChatField(
              recieverUser: widget.receiver,
            ),
          ],
        ),
      );
  }
}

