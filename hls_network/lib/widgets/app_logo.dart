import 'package:flutter/material.dart';

class MyAppLogo extends StatelessWidget {
  final String path;
  const MyAppLogo({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 55, width: 55, child: Image.asset(path));
  }
}

class MyAppIcon extends StatelessWidget {
  final String path;
  const MyAppIcon({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 65, width: 65, child: Image.asset(path));
  }
}
