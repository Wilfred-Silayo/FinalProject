import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/screens.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/features/home/widgets/custom_circular_avator.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  void showOptions() {
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
        height: 100,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Account'),
              onTap: () {
                ref
                    .read(authControllerProvider.notifier)
                    .deleteAccount(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(currentUserDetailsProvider).when(
        data: (user) {
          return Drawer(
            backgroundColor: currentTheme.drawerTheme.backgroundColor,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomCircularAvator(
                        photoUrl: user.profilePic,
                        radius: 40,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                "${user.fullName}@${user.username}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Followers: ${user.followers.length}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Following: ${user.following.length}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: currentTheme.brightness == Brightness.light
                        ? currentTheme.colorScheme.secondary
                        : Pallete.whiteColor,
                  ),
                  title: const Text(
                    "Profile",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      UserProfileView.route(user),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.security,
                    color: currentTheme.brightness == Brightness.light
                        ? currentTheme.colorScheme.secondary
                        : Pallete.whiteColor,
                  ),
                  title: const Text(
                    "Security",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Security()),
                    );
                  },
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    leading: currentTheme.brightness == Brightness.light
                        ? Icon(
                            Icons.light_mode,
                            color: currentTheme.colorScheme.secondary,
                          )
                        : const Icon(
                            Icons.dark_mode,
                            color: Pallete.whiteColor,
                          ),
                    title: Text(
                      'Themes',
                      style: TextStyle(
                          fontSize: 18,
                          color: currentTheme.brightness == Brightness.light
                              ? Pallete.blackColor
                              : Pallete.whiteColor),
                    ),
                    children: [
                      ListTile(
                        leading: const SizedBox(
                          width: 6,
                        ),
                        title: const Text(
                          'Light Mode',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Switch(
                          value:
                              ref.watch(themeNotifierProvider.notifier).mode ==
                                  ThemeMode.light,
                          onChanged: (value) {
                            if (!value) {
                              ref
                                  .read(themeNotifierProvider.notifier)
                                  .toggleTheme();
                            }
                          },
                        ),
                        onTap: () {
                          ref
                              .read(themeNotifierProvider.notifier)
                              .toggleTheme();
                        },
                      ),
                      ListTile(
                        leading: const SizedBox(
                          width: 6,
                        ),
                        title: const Text(
                          'Dark Mode',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Switch(
                          value:
                              ref.watch(themeNotifierProvider.notifier).mode ==
                                  ThemeMode.dark,
                          onChanged: (value) {
                            if (value) {
                              ref
                                  .read(themeNotifierProvider.notifier)
                                  .toggleTheme();
                            } else {
                              ref
                                  .read(themeNotifierProvider.notifier)
                                  .toggleTheme();
                            }
                          },
                        ),
                        onTap: () {
                          ref
                              .read(themeNotifierProvider.notifier)
                              .toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: currentTheme.brightness == Brightness.light
                        ? currentTheme.colorScheme.secondary
                        : Pallete.whiteColor,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () async {
                    ref.read(authControllerProvider.notifier).logout(context);
                  },
                ),
                const Divider(
                  thickness: 2.0,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    showOptions();
                  },
                ),
              ],
            ),
          );
        },
        error: (error, st) => ErrorText(
              error: error.toString(),
            ),
        loading: () => const Loader());
  }
}
