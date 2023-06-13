import 'package:flutter/material.dart';
import 'package:hls_network/features/posts/widgets/appbar.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/features/home/widgets/drawer.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/screens.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  static const List<Widget> _pages = [
    HomePage(),
    Search(),
    Conferences(),
    Notifications(),
    DirectMessages(),
  ];

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a Photo'),
                onTap: () {
                  // Handle option selection
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Choose from Gallery'),
                onTap: () {
                  // Handle option selection
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      extendBody: true,
      appBar: _page == 0
          ? StaticAppBar(
              lightImagePath: "assets/appicon.png",
              darkImagePath: "assets/logo.png",
              currentThemeBrightness: currentTheme.brightness,
            )
          : null,
      drawer: _page == 0 ? const DrawerWidget() : null,
      body: IndexedStack(
        index: _page,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20.0,
        onPressed: () => _showOptions(context),
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
          index: _page,
          items: const <Widget>[
            Icon(Icons.home, size: 25),
            Icon(Icons.search, size: 25),
            Icon(Icons.meeting_room, size: 25),
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
