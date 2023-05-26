import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/themes/themes_helper.dart';

class SquareTile extends ConsumerWidget {
  final String path;
  const SquareTile({
    super.key,
    required this.path, 
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Container(
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: currentTheme.brightness==Brightness.dark? Colors.white:Colors.black),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
      ),
    );
  }
}
