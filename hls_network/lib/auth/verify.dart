import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/auth/verification_token.dart';
import 'dart:convert';
import '../controller/sims_api.dart';
import '../themes/themes_helper.dart';
import '../utils/utils.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String uniName;
  final String apiUrl;
  final String description;
  const VerificationScreen({
    Key? key,
    required this.uniName,
    required this.apiUrl,
    required this.description,
  }) : super(key: key);

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final regNoController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    regNoController.dispose();
  }

  void verifyRegistrationNumber(context) async {
    if (regNoController.text.isEmpty) {
      String res = 'Registration number can\'t be empty.';
      showSnackBar(context, res);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await SimsApi(baseUrl: widget.apiUrl)
          .generateToken(regNoController.text);
      if (response.statusCode == 200) {
        final message = responseMessage(response);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TokenVerification(
              regNumber: regNoController.text,
              message: message,
              uniName: widget.uniName,
              apiUrl: widget.apiUrl,
            ),
          ),
        );
      } else {
        String res = responseMessage(response);
        showSnackBar(context, res);
      }
    } catch (error) {
      String res = 'Something went wrong.';
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

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Text(
              'Please verify that you come from ${widget.description} [${widget.uniName}] by entering your ${widget.uniName} registration number.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: regNoController,
              decoration: InputDecoration(
                labelText: 'Enter Registration Number',
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
