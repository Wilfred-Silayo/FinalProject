import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/home/widgets/custom_circular_avator.dart';
import 'package:hls_network/features/posts/widgets/post_card.dart';
import 'package:hls_network/features/profile/controller/user_profile_controller.dart';
import 'package:hls_network/features/profile/view/edit_profile.dart';
import 'package:hls_network/features/profile/view/followers.dart';
import 'package:hls_network/features/profile/view/followings.dart';
import 'package:hls_network/features/profile/widgets/follow_count.dart';
import 'package:hls_network/models/university.dart';
import 'package:hls_network/models/user_model.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';
import 'package:hls_network/themes/themes_helper.dart' as pallete;

class UserProfile extends ConsumerWidget {
  final UserModel user;
  final University? university;
  const UserProfile({
    super.key,
    required this.user,
    required this.university,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container()
                            : CachedNetworkImage(
                                imageUrl: user.bannerPic,
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                  color: pallete.Pallete.whiteColor,
                                )),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CustomCircularAvator(
                            photoUrl: user.profilePic, radius: 45),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            currentUser.uid != user.uid
                                ? IconButton(
                                    onPressed: () {},
                                    icon: const Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.message,
                                        size: 30,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            OutlinedButton(
                              onPressed: () {
                                if (currentUser.uid == user.uid) {
                                  // edit profile
                                  Navigator.push(
                                      context, EditProfileView.route());
                                } else {
                                  ref
                                      .read(userProfileControllerProvider
                                          .notifier)
                                      .followUser(
                                        user: user,
                                        context: context,
                                        currentUser: currentUser,
                                      );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pallete.Pallete.tealColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: pallete.Pallete.whiteColor,
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                              ),
                              child: Text(
                                currentUser.uid == user.uid
                                    ? 'Edit Profile'
                                    : currentUser.following.contains(user.uid)
                                        ? 'Unfollow'
                                        : 'Follow',
                                style: const TextStyle(
                                  color: pallete.Pallete.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              user.fullName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '@${user.username}',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        if (university != null)
                          Text(
                            '${university!.description} [${university!.name}] ~ ${user.verifiedAs}.',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, Followings.route(user));
                              },
                              child: FollowCount(
                                count: user.following.length,
                                text: 'Following',
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                                onTap: () {
                                Navigator.push(context, Followers.route(user));
                              },
                              child: FollowCount(
                                count: user.followers.length,
                                text: 'Followers',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Divider(
                          color: pallete.Pallete.tealColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserPostsProvider(user.uid)).when(
                  data: (posts) {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          );
  }
}
