import 'package:flutter/material.dart';

class DirectMessages extends StatefulWidget {
  const DirectMessages({Key? key}) : super(key: key);

  @override
  State<DirectMessages> createState() => _DirectMessagesState();
}

class _DirectMessagesState extends State<DirectMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
    );
  }
}
