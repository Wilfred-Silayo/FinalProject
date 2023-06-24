import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/posts/controller/post_controller.dart';
import 'package:hls_network/features/posts/widgets/post_card.dart';
import 'package:hls_network/models/post.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class PostReplyScreen extends ConsumerWidget {
  static Route<dynamic> route(Post post) {
    return MaterialPageRoute<dynamic>(
      builder: (context) => ProviderScope(
        child: PostReplyScreen(post: post),
      ),
    );
  }

  final Post post;

  const PostReplyScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          PostCard(post: post),
          ref.watch(getRepliesToPostsProvider(post)).when(
                data: (posts) {
                  return ref.watch(getLatestPostsProvider).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return PostCard(post: post);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = posts[index];
                                return PostCard(post: post);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(postControllerProvider.notifier).sharePost(
            images: [],
            text: value,
            context: context,
            repliedTo: post.id,
            repliedToUserId: post.uid,
          );
        },
        decoration: const InputDecoration(
          hintText: 'Reply',
        ),
      ),
    );
  }
}
