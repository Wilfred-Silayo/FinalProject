import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hls_network/widgets/drawer.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/screens.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../widgets/app_logo.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 2;
  final List _pages = const <Widget>[
    Conferences(),
    Groups(),
    Homepage(),
    Notifications(),
    DirectMessages(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      extendBody: true,
      appBar: _page == 2
          ? AppBar(
              centerTitle: true,
              title: currentTheme.brightness == Brightness.light
                  ? const MyAppLogo(path: "assets/appicon.png")
                  : const MyAppLogo(path: "assets/logo.png"),
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints.expand(height: 50),
                      child: const Center(
                        child: Text(
                          'Social Higher learning',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 1.0,
                      child: Divider(color: Color(0xff37678a)),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Search(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                ),
              ],
            )
          : null,
      drawer: _page == 2 ? const DrawerWidget() : null,
      body: _pages[_page],
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
          index: _page,
          items: const <Widget>[
            Icon(Icons.podcasts, size: 25),
            Icon(Icons.group_sharp, size: 25),
            Icon(Icons.home, size: 25),
            Icon(Icons.notifications, size: 25),
            Icon(Icons.message, size: 25),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
      ),
    );
  }
}
