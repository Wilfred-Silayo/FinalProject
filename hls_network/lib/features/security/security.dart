import 'package:flutter/material.dart';
import 'package:hls_network/features/security/change_email.dart';
import 'package:hls_network/features/security/change_password.dart';
import 'package:hls_network/features/security/verify_email.dart';

class Security extends StatelessWidget {
  const Security({super.key});

  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
    );
  }
}
