import 'package:flutter/material.dart';
import 'package:hls_network/features/home/widgets/custom_circular_avator.dart';
import 'package:hls_network/features/profile/view/profile.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/themes/themes_helper.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          UserProfileView.route(userModel),
        );
      },
      leading: CustomCircularAvator(
        photoUrl: userModel.profilePic,
        radius: 30,
      ),
      title: Text(
        userModel.fullName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.username}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            userModel.bio,
            style: const TextStyle(
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
