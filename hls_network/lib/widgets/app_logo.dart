import 'package:flutter/material.dart';

class MyAppLogo extends StatelessWidget {
  final String path;
  const MyAppLogo({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 60, width: 60, child: Image.asset(path));
  }
}
