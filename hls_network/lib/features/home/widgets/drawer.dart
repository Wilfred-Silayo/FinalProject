import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/screens.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/features/home/widgets/custom_circularAvator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  String? photoUrl;
  String? fullName;
  String? username;
  int followersCount = 0;
  int followingCount = 0;

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final userData = userDoc.data() as Map<String, dynamic>;

      setState(() {
        photoUrl = userData['photoUrl'] ?? '';
        fullName = userData['fullName'] ?? '';
        username = userData['username'] ?? '';
        followersCount = userData['followers'].length;
        followingCount = userData['following'].length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Drawer(
      backgroundColor: currentTheme.drawerTheme.backgroundColor,
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCircularAvator(photoUrl:photoUrl,radius:40,),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$fullName@$username",
                        style: const TextStyle(fontSize: 16),
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
                        'Followers: $followersCount',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Following: $followingCount',
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
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip,
                color: currentTheme.brightness == Brightness.light
                    ? currentTheme.colorScheme.secondary
                    : Pallete.whiteColor,
              ),
              title: const Text(
                "Privacy",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Privacy()),
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
                      value: ref.watch(themeNotifierProvider.notifier).mode ==
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
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
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
                      value: ref.watch(themeNotifierProvider.notifier).mode ==
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
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
