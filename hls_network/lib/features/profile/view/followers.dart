import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/search/widgets/search_tile.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class Followers extends ConsumerWidget {
  static Route<dynamic> route(UserModel user) {
    return MaterialPageRoute(
      builder: (context) => Followers(
        user: user,
      ),
    );
  }

  final UserModel user;

  const Followers({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: ListView.builder(
        itemCount: user.followers.length,
        itemBuilder: (context, index) {
          final followerId = user.followers[index];

          final userModel = ref.watch(userDetailsProvider(followerId));

          return userModel.when(
            data: (userModel) {
              return SearchTile(userModel: userModel);
            },
            loading: () => const Loader(),
            error: (error, stackTrace) =>
                ErrorText(error: error.toString()),
          );
        },
      ),
    );
  }
}
