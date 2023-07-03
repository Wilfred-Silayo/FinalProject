import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/security/change_email.dart';
import 'package:hls_network/features/security/change_password.dart';
import 'package:hls_network/features/security/verify_email.dart';
import 'package:hls_network/providers/theme_provider.dart';

class Security extends ConsumerWidget {
  const Security({super.key});
  void showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      backgroundColor: ref.read(themeNotifierProvider).colorScheme.primary,
      builder: (context) => SizedBox(
        height: 100,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Account'),
              onTap: () {
                ref
                    .read(authControllerProvider.notifier)
                    .deleteAccount(context);
              },
            ),
          ],
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text(
              'Change password',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Its is recommended to change your password regulary',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePassword(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text(
              'Change email',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'You can change your email',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeEmail(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text(
              'Verify your email',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Its is recommended to verify your email, so that you can recover your account in case you forgot your password.',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerifyEmail(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            title: const Text(
              "Delete Account",
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Perfoming this action will erase all you information',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              showOptions(context, ref);
            },
          ),
        ],
      ),
    );
  }
}
