import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/themes/themes_helper.dart';

class ChangeEmail extends ConsumerStatefulWidget {
  const ChangeEmail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends ConsumerState<ChangeEmail> {
  final _newEmailController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _newEmailController,
              decoration: const InputDecoration(
                labelText: 'New Email',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _changeEmail(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Pallete.tealColor,
                ),
              ),
              child: const Text('Change Email',
                  style: TextStyle(color: Colors.white)),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  void _changeEmail(BuildContext context) {
    final newEmail = _newEmailController.text;

    if (newEmail.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a new email.';
      });
      return;
    }
    ref.read(authControllerProvider.notifier).changeEmail(context, newEmail);
    _newEmailController.text='';   
  }
}
