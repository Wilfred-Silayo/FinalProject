import 'package:flutter/material.dart';
import 'package:hls_network/features/home/widgets/app_logo.dart';

class StaticAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String lightImagePath;
  final String darkImagePath;
  final Brightness currentThemeBrightness;

  const StaticAppBar({
    super.key,
    required this.lightImagePath,
    required this.darkImagePath,
    required this.currentThemeBrightness
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: currentThemeBrightness == Brightness.light
          ? MyAppIcon(path: lightImagePath)
          : MyAppLogo(path: darkImagePath),
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
    );
  }
}
