import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/home/widgets/textfield.dart';
import 'package:hls_network/features/auth/widgets/button.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/utils/loading_page.dart';


class Register extends ConsumerStatefulWidget {
  final String uniId;
  final String status;
  const Register({
    Key? key,
    required this.uniId,
    required this.status,
  }) : super(key: key);

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  bool _obscureText = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() async {
    ref.read(authControllerProvider.notifier).signUp(
          email: _emailController.text,
          fullName: _fullNameController.text,
          password: _passwordController.text,
          uniId: widget.uniId,
          verifiedAs: widget.status,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Create an account ',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 30),
                      FormInputField(
                        textController: _fullNameController,
                        hintText: 'Full name',
                        obscureText: false,
                        prefixIcon: Icon(
                          Icons.person,
                          color: currentTheme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FormInputField(
                        textController: _emailController,
                        hintText: 'Email',
                        obscureText: false,
                        prefixIcon: Icon(
                          Icons.email,
                          color: currentTheme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FormInputField(
                        textController: _passwordController,
                        hintText: 'Password',
                        obscureText: !_obscureText,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: currentTheme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        suffixIcon: _obscureText
                            ? Icon(
                                Icons.visibility,
                                color: currentTheme.colorScheme.secondary,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: currentTheme.colorScheme.secondary,
                              ),
                        onSuffixIconTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      MyButton(onTap: signUpUser, text: 'Register'),
                      SizedBox(height: size.height / 9),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
