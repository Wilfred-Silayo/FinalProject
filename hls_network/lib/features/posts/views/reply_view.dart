import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/posts/controller/post_controller.dart';
import 'package:hls_network/features/posts/widgets/post_card.dart';
import 'package:hls_network/models/post.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class PostReplyScreen extends ConsumerStatefulWidget {
  static Route<dynamic> route(Post post) {
    return MaterialPageRoute<dynamic>(
      builder: (context) => PostReplyScreen(post: post),
    );
  }

  final Post post;

  const PostReplyScreen({Key? key, required this.post}) : super(key: key);

  @override
  ConsumerState<PostReplyScreen> createState() => _PostReplyScreenState();
}

class _PostReplyScreenState extends ConsumerState<PostReplyScreen> {
  final TextEditingController postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              PostCard(post: widget.post),
              ref.watch(getRepliesToPostsProvider(widget.post)).when(
                    data: (posts) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = posts[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
              const SizedBox(
                height: 6,
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: postTextController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: currentTheme.brightness == Brightness.dark
                              ? Pallete.searchBarColor
                              : Pallete.tealColor,
                          hintText: 'Reply',
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF128C7E),
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Pallete.whiteColor),
                      onPressed: () {
                        ref.read(postControllerProvider.notifier).sharePost(
                          images: [],
                          text: postTextController.text,
                          context: context,
                          repliedTo: widget.post.id,
                          repliedToUserId: widget.post.uid,
                        );
                        postTextController.text = '';
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
