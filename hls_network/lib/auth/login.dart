import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/widgets/textfield.dart';
import 'package:hls_network/widgets/button.dart';
import 'package:hls_network/auth/register.dart';
import 'package:hls_network/widgets/square_tile.dart';
import 'package:hls_network/themes/themes_helper.dart';
import '../controller/auth_method.dart';
import '../features/home_screen.dart';
import '../utils/utils.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    showLoadingDialog(context);
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pop();
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
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
                          color: currentTheme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: currentTheme.brightness == Brightness.dark
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
                    children: const [
                      Text(
                        'Forgot Password?',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                MyButton(onTap: loginUser, text: 'Login'),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          thickness: 0.6,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Or continue with',
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.6,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SquareTile(path: 'assets/google.png'),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
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
                                builder: (context) => const Register()),
                          );
                        });
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
