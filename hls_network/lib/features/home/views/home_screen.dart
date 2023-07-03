import 'package:flutter/material.dart';
import 'package:hls_network/features/messages/views/search_user.dart';
import 'package:hls_network/features/posts/views/create_post.dart';
import 'package:hls_network/features/posts/widgets/appbar.dart';
import 'package:hls_network/features/posts/widgets/posts_list.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/features/home/widgets/drawer.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/screens.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int page = 0;

  static const List<Widget> pages = [
    PostList(),
    Search(),
    Conferences(),
    NotificationView(),
    DirectMessages(),
  ];

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
        height: 400,
        child: ListView(
          children: [
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('New post'),
              onTap: () {
                Navigator.push(context, CreatePost.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text('New Chat'),
              onTap: () {Navigator.push(context, SearchUser.route());},
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_voice),
              title: const Text('New audio conference'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text('New video conference'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      extendBody: true,
      appBar: page == 0
          ? StaticAppBar(
              lightImagePath: "assets/appicon.png",
              darkImagePath: "assets/logo.png",
              currentThemeBrightness: currentTheme.brightness,
            )
          : null,
      drawer: page == 0 ? const DrawerWidget() : null,
      body: IndexedStack(
        index: page,
        children: pages,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20.0,
        onPressed: showOptions,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        child: CurvedNavigationBar(
          height: 60,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          buttonBackgroundColor: Pallete.redColor,
          backgroundColor: Colors.transparent,
          color: currentTheme.brightness == Brightness.light
              ? Pallete.tealColor
              : Pallete.appBarColor,
          index: page,
          items: const <Widget>[
            Icon(Icons.home, size: 25),
            Icon(Icons.search, size: 25),
            Icon(Icons.meeting_room, size: 25),
            Icon(Icons.notifications, size: 25),
            Icon(Icons.message, size: 25),
          ],
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
        ),
      ),
    );
  }
}
