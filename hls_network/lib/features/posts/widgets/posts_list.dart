import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/posts/controller/post_controller.dart';
import 'package:hls_network/features/posts/widgets/post_card.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class PostList extends ConsumerWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      body: currentUser == null
          ? const Loader()
          : ref.watch(getPostsProvider(currentUser)).when(
                data: (posts) {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = posts[index];
                          return PostCard(post: post);
                    },
                  );
                },
                error: (error, stackTrace) { 
                      return ErrorText(
                  error: error.toString());
                },
                loading: () => const Loader(),
              ),
    );
  }
}
