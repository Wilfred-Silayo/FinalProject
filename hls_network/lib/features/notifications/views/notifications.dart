import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/notifications/controller/notification_controller.dart';
import 'package:hls_network/features/notifications/widgets/notification_tile.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      final notification = notifications[index];
                      return NotificationTile(
                        notification: notification,
                      );
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
