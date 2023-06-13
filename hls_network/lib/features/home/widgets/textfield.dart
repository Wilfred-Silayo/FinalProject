import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/themes/themes_helper.dart';
import '../../../providers/theme_provider.dart';

class FormInputField extends ConsumerWidget {
  final TextEditingController textController;
  final String hintText;
  final bool obscureText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Function()? onSuffixIconTap;

  const FormInputField({
    super.key,
    required this.textController,
    required this.obscureText,
    required this.hintText,
    this.onSuffixIconTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: textController,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: currentTheme.colorScheme.secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2.0,
              color: Pallete.tealColor,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          fillColor: currentTheme.brightness == Brightness.dark
              ? Pallete.drawerColor
              : Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: currentTheme.brightness == Brightness.dark
                ? const Color.fromARGB(255, 223, 217, 217)
                : const Color.fromARGB(255, 26, 25, 25),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon != null
              ? InkWell(
                  onTap: onSuffixIconTap,
                  child: suffixIcon,
                )
              : null,
        ),
        cursorColor: Pallete.tealColor,
        style: TextStyle(
          color: currentTheme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
