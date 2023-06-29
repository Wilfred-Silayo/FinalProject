import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/home/widgets/custom_circular_avator.dart';
import 'package:hls_network/features/posts/widgets/post_icon_button.dart';
import 'package:hls_network/features/profile/controller/user_profile_controller.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/utils/loading_page.dart';
import 'package:like_button/like_button.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/posts/controller/post_controller.dart';
import 'package:hls_network/features/posts/views/reply_view.dart';
import 'package:hls_network/features/posts/widgets/carousel_image.dart';
import 'package:hls_network/features/posts/widgets/hashtag_text.dart';
import 'package:hls_network/features/profile/view/profile.dart';
import 'package:hls_network/models/post.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/enums/post_type.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  void showOptions(UserModel currentUser, Post post) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      backgroundColor: ref.read(themeNotifierProvider).colorScheme.primary,
      builder: (context) => SizedBox(
        height: 200,
        child: ListView(
          children: [
            currentUser.uid == post.uid
                ? ListTile(
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Delete post',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      ref
                          .read(postControllerProvider.notifier)
                          .deletePost(post, context);
                      Navigator.pop(context);
                    },
                  )
                : ListTile(
                    leading: const Icon(Icons.person),
                    title: currentUser.followers.contains(post.uid)
                        ? const Text(
                            'Unfollow',
                            style: TextStyle(
                              color: Pallete.tealColor,
                            ),
                          )
                        : const Text(
                            'Follow',
                            style: TextStyle(
                              color: Pallete.tealColor,
                            ),
                          ),
                    onTap: () {
                      ref
                          .read(userProfileControllerProvider.notifier)
                          .followUser(
                            user:
                                ref.read(userDetailsProvider(post.uid)).value!,
                            context: context,
                            currentUser: currentUser,
                          );
                      setState(() {
                        currentUser =
                            ref.read(currentUserDetailsProvider).value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final currentTheme = ref.watch(themeNotifierProvider);

    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(widget.post.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PostReplyScreen.route(widget.post),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  UserProfileView.route(user),
                                );
                              },
                              child: CustomCircularAvator(
                                photoUrl: user.profilePic,
                                radius: 25,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      title: Text(
                                        user.fullName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      subtitle: widget.post.repliedTo.isNotEmpty
                                          ? ref
                                              .watch(getPostByIdProvider(
                                                  widget.post.repliedTo))
                                              .when(
                                                data: (repliedToPost) {
                                                  final replyingToUser = ref
                                                      .watch(
                                                        userDetailsProvider(
                                                          repliedToPost.uid,
                                                        ),
                                                      )
                                                      .value;
                                                  return RichText(
                                                    text: TextSpan(
                                                      text: '@${user.username}',
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 16,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: ' Replied to ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: currentTheme
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              ' @${replyingToUser?.username}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                error: (error, st) => ErrorText(
                                                  error: error.toString(),
                                                ),
                                                loading: () => const SizedBox(),
                                              )
                                          : Text('@${user.username}'),
                                      trailing: IconButton(
                                          icon: const Icon(Icons.more_vert),
                                          onPressed: () => showOptions(
                                              currentUser, widget.post))),
                                  Text(
                                    '· ${timeago.format(
                                      widget.post.postedAt,
                                    )}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: HashtagText(text: widget.post.text)),
                        ),
                        const SizedBox(height: 10.0),
                        if (widget.post.postType == PostType.image)
                          CarouselImage(imageLinks: widget.post.imageLinks),
                        if (widget.post.link.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          AnyLinkPreview(
                            displayDirection: UIDirection.uiDirectionHorizontal,
                            link: 'https://${widget.post.link}',
                          ),
                        ],
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PostIconButton(
                              text: ref
                                  .watch(getRepliesToPostsProvider(widget.post))
                                  .maybeWhen(
                                    data: (posts) => posts.length.toString(),
                                    orElse: () => '',
                                  ),
                              onTap: () {},
                            ),
                            LikeButton(
                              size: 25,
                              onTap: (isLiked) async {
                                ref
                                    .read(postControllerProvider.notifier)
                                    .likePost(
                                      widget.post,
                                      currentUser,
                                    );
                                return !isLiked;
                              },
                              isLiked:
                                  widget.post.likes.contains(currentUser.uid),
                              likeBuilder: (isLiked) {
                                return isLiked
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined);
                              },
                              likeCount: widget.post.likes.length,
                              countBuilder: (likeCount, isLiked, text) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: isLiked
                                          ? Pallete.redColor
                                          : Pallete.whiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share_outlined,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}


//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(currentUserDetailsProvider).value;

//     return currentUser == null
//         ? const SizedBox()
//         : ref.watch(userDetailsProvider(post.uid)).when(
//               data: (user) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       PostReplyScreen.route(post),
//                     );
//                   },
//                   child: Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.all(10),
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   UserProfileView.route(user),
//                                 );
//                               },
//                               child: CustomCircularAvator(
//                                 photoUrl: user.profilePic,
//                                 radius: 30,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       margin: const EdgeInsets.only(
//                                         right: 5,
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Text(
//                                             user.fullName,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           Text(
//                                             '· ${timeago.format(
//                                               post.postedAt,
//                                               locale: 'en_short',
//                                             )}',
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Text(
//                                           '@${user.username}',
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 if (post.repliedTo.isNotEmpty)
//                                   ref
//                                       .watch(
//                                           getPostByIdProvider(post.repliedTo))
//                                       .when(
//                                         data: (repliedToPost) {
//                                           final replyingToUser = ref
//                                               .watch(
//                                                 userDetailsProvider(
//                                                   repliedToPost.uid,
//                                                 ),
//                                               )
//                                               .value;
//                                           return RichText(
//                                             text: TextSpan(
//                                               text: 'Replying to',
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                               ),
//                                               children: [
//                                                 TextSpan(
//                                                   text:
//                                                       ' @${replyingToUser?.username}',
//                                                   style: const TextStyle(
//                                                     color: Colors.blue,
//                                                     fontSize: 16,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                         error: (error, st) => ErrorText(
//                                           error: error.toString(),
//                                         ),
//                                         loading: () => const SizedBox(),
//                                       ),
//                                 HashtagText(text: post.text),
//                                 if (post.postType == PostType.image)
//                                   CarouselImage(imageLinks: post.imageLinks),
//                                 if (post.link.isNotEmpty) ...[
//                                   const SizedBox(height: 4),
//                                   AnyLinkPreview(
//                                     displayDirection:
//                                         UIDirection.uiDirectionHorizontal,
//                                     link: 'https://${post.link}',
//                                   ),
//                                 ],
//                                 Container(
//                                   margin: const EdgeInsets.only(
//                                     top: 10,
//                                     right: 20,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       PostIconButton(
//                                         text: ref
//                                             .watch(
//                                                 getRepliesToPostsProvider(post))
//                                             .maybeWhen(
//                                               data: (posts) =>
//                                                   posts.length.toString(),
//                                               orElse: () => '',
//                                             ),
//                                         onTap: () {},
//                                       ),
//                                       LikeButton(
//                                         size: 25,
//                                         onTap: (isLiked) async {
//                                           ref
//                                               .read(postControllerProvider
//                                                   .notifier)
//                                               .likePost(
//                                                 post,
//                                                 currentUser,
//                                               );
//                                           return !isLiked;
//                                         },
//                                         isLiked: post.likes
//                                             .contains(currentUser.uid),
//                                         likeBuilder: (isLiked) {
//                                           return isLiked
//                                               ? const Icon(
//                                                   Icons.favorite,
//                                                   color: Colors.red,
//                                                 )
//                                               : const Icon(Icons
//                                                   .favorite_border_outlined);
//                                         },
//                                         likeCount: post.likes.length,
//                                         countBuilder:
//                                             (likeCount, isLiked, text) {
//                                           return Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 2.0),
//                                             child: Text(
//                                               text,
//                                               style: TextStyle(
//                                                 color: isLiked
//                                                     ? Pallete.redColor
//                                                     : Pallete.whiteColor,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                       IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.share_outlined,
//                                           size: 25,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 1),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(color: Pallete.greyColor),
//                     ],
//                   ),
//                 );
//               },
//               error: (error, stackTrace) => ErrorText(
//                 error: error.toString(),
//               ),
//               loading: () => const Loader(),
//             );
//   }
// }
