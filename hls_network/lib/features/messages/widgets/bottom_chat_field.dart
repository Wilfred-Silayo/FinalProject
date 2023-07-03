import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/messages/controller/message_controller.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/themes/themes_helper.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final UserModel recieverUser;

  const BottomChatField({
    Key? key,
    required this.recieverUser,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void sendTextMessage(UserModel currentUser) async {
    if (isShowSendButton) {
      ref.read(messageControllerProvider.notifier).sendTextMessage(
          context: context,
          receiver: widget.recieverUser,
          sender: currentUser,
          text: _messageController.text.trim());
      setState(() {
        _messageController.text = '';
      });
    }
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null
        ? const SizedBox()
        : Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: _messageController,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            isShowSendButton = true;
                          });
                        } else {
                          setState(() {
                            isShowSendButton = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: currentTheme.brightness == Brightness.dark
                            ? Pallete.searchBarColor
                            : Pallete.whiteColor,
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 2,
                      left: 2,
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF128C7E),
                      radius: 25,
                      child: GestureDetector(
                        onTap: ()=>sendTextMessage(currentUser),
                        child: Icon(
                          isShowSendButton
                              ? Icons.send : null,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
