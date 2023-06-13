import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/views/register.dart';
import '../../../Apis/sims_api.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/themes_helper.dart';
import '../../../utils/utils.dart';

class TokenVerification extends ConsumerStatefulWidget {
  final String regNumber;
  final String uniId;
  final String apiUrl;
  const TokenVerification(
      {super.key,
      required this.regNumber,
      required this.uniId,
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
        final status = responseStatus(response);
        String res = "Verification successful";
        showSnackBar(context, res);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Register(
                status: status,
                uniId: widget.uniId,
              ),
            ),
            (route) => false);
      } else {
        String res = responseMessage(response);
        showSnackBar(context, res);
      }
    } catch (error) {
      String res = 'Please check your internet connection.';
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
    return responseData['message'];
  }

  String responseStatus(response) {
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
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
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
