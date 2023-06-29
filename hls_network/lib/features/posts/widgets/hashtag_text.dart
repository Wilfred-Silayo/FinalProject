import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/posts/views/hashtag_view.dart';
import 'package:hls_network/providers/theme_provider.dart';

class HashtagText extends ConsumerWidget {
  final String text;
  const HashtagText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    List<TextSpan> textspans = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  HashtagView.route(element),
                );
              },
          ),
        );
      }
      else if (element.startsWith('www.') || element.startsWith('https://')) {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
        );
      } else {
        textspans.add(
          TextSpan(
            text: '$element ',
            style: TextStyle(
              fontSize: 18,
              color: currentTheme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        );
      }
    });

    return RichText(
      text: TextSpan(
        children: textspans,
      ),
    );
  }
}
