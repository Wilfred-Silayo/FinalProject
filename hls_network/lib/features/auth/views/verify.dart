import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/views/verification_token.dart';
import 'dart:convert';
import '../../../Apis/sims_api.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/themes_helper.dart';
import '../../../utils/utils.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String uniName;
  final String uniId;
  final String apiUrl;
  final String description;
  const VerificationScreen({
    Key? key,
    required this.uniName,
    required this.uniId,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TokenVerification(
              regNumber: regNoController.text,
              uniId: widget.uniId,
              apiUrl: widget.apiUrl,
            ),
          ),
        );
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
