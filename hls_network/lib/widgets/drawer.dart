import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/screens.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        backgroundColor: Pallete.appBarColor,
                        radius: 50.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("username"),
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
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
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
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
