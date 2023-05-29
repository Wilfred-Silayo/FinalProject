import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/home_screen.dart';
import 'package:hls_network/widgets/textfield.dart';
import 'package:hls_network/widgets/button.dart';
import 'package:hls_network/widgets/square_tile.dart';
import 'package:hls_network/themes/themes_helper.dart';
import '../controller/auth_method.dart';
import '../utils/utils.dart';
import 'login.dart';

class Register extends ConsumerStatefulWidget {
  final String uniName;
  final String status;
  const Register({Key? key,required this.uniName,required this.status}) : super(key: key);

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    showLoadingDialog(context);
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      verifiedAs:widget.status,
      uniName:widget.uniName,
    );

    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Create account',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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
                        'Or register with',
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
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
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
                                builder: (context) => const Login()),
                          );
                        });
                      },
                      child: const Text(
                        'Login now',
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
