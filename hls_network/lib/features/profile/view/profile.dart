import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/profile/controller/user_profile_controller.dart';
import 'package:hls_network/features/profile/widgets/user_profile.dart';
import 'package:hls_network/models/university.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/error_page.dart';

class UserProfileView extends ConsumerWidget {
  static Route<dynamic> route(UserModel userModel) {
    return MaterialPageRoute(
      builder: (context) => UserProfileView(
        userModel: userModel,
      ),
    );
  }

  final UserModel userModel;

  const UserProfileView({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = userModel;
    University? university;

    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider(userModel.uid)).when(
        data: (data) {
          copyOfUser = data;

          return ref.watch(getUniversityProvider(copyOfUser.university)).when(
            data: (universityData) {
              university = University.fromMap(universityData.data() as Map<String,dynamic>);
              return UserProfile(user: copyOfUser, university: university);
            },
            error: (error, st) => ErrorText(
              error: error.toString(),
            ),
            loading: () => UserProfile(user: copyOfUser,university: university),
          );
        },
        error: (error, st) => ErrorText(
          error: error.toString(),
        ),
        loading: () => UserProfile(user: copyOfUser, university: university),
      ),
    );
  }
}
