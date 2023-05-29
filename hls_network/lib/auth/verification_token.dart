import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/auth/register.dart';
import '../controller/sims_api.dart';
import '../themes/themes_helper.dart';
import '../utils/utils.dart';

class TokenVerification extends ConsumerStatefulWidget {
  final String regNumber;
  final String message;
  final String uniName;
  final String apiUrl;
  const TokenVerification(
      {super.key,
      required this.regNumber,
      required this.message,
      required this.uniName,
      required this.apiUrl});

  @override
  ConsumerState<TokenVerification> createState() => _TokenVerificationState();
}

class _TokenVerificationState extends ConsumerState<TokenVerification> {
  final tokenController = TextEditingController();
  final String message =
      'Token generated successfully. We have sent you the token in your email that you used to register in your College, Institute or University. Also, you can find it in your SIMS account.';
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    tokenController.dispose();
  }

  void verifyRegistrationNumber(context) async {
    if (tokenController.text.isEmpty) {
      String res = 'Token can\'t be empty.';
      showSnackBar(context, res);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await SimsApi(baseUrl: widget.apiUrl)
          .verifyToken(widget.regNumber, tokenController.text);
      if (response.statusCode == 200) {
        final status = responseMessage(response);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Register(
                status: status,
                uniName: widget.uniName,
              ),
            ),
            (route) => false);
      } else {
        String res = responseMessage(response);
        showSnackBar(context, res);
      }
    } catch (error) {
      String res = 'Invalid token.';
      showSnackBar(context, res);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String responseMessage(response) {
    String responseBody = response.body;
    Map<String, dynamic> responseData = jsonDecode(responseBody);
    return responseData['status'];
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Token'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(
                labelText: 'Enter Verification token',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: currentTheme.colorScheme.secondary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: currentTheme.colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () =>
                  isLoading ? null : verifyRegistrationNumber(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Pallete.tealColor,
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
