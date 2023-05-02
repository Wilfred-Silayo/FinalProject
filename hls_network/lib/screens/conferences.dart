import 'package:flutter/material.dart';

class Conferences extends StatefulWidget {
  const Conferences({Key? key}) : super(key: key);

  @override
  State<Conferences> createState() => _ConferencesState();
}

class _ConferencesState extends State<Conferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
    );
  }
}
