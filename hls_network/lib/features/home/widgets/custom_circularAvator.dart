import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../themes/themes_helper.dart';

class CustomCircularAvator extends StatelessWidget {
  final String? photoUrl;
  final double radius;
  const CustomCircularAvator({super.key, required this.photoUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Pallete.appBarColor,
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(photoUrl!),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Pallete.appBarColor,
        radius: radius,
        backgroundImage:const AssetImage('assets/user.png'),
      );
    }
  }
}
