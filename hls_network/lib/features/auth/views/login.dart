import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/auth/views/forgot_password.dart';
import 'package:hls_network/features/auth/views/welcome.dart';
import 'package:hls_network/features/home/widgets/textfield.dart';
import 'package:hls_network/features/auth/widgets/button.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/utils/loading_page.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() {
    ref.read(authControllerProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FormInputField(
                        textController: _emailController,
                        hintText: 'Email',
                        obscureText: false,
                        prefixIcon: Icon(
                          Icons.keyboard,
                          color: currentTheme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
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
                                color:
                                    currentTheme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color:
                                    currentTheme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                              ),
                        onSuffixIconTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PasswordReset()),
                                  );
                                });
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      MyButton(onTap: loginUser, text: 'Login'),
                      SizedBox(height: size.height / 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Welcome()),
                                );
                              });
                            },
                            child: const Text(
                              'Register now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
