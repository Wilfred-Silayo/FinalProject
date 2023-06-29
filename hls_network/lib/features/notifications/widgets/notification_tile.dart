import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/notifications/controller/notification_controller.dart';
import 'package:hls_network/providers/theme_provider.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/enums/notification_type.dart';
import 'package:hls_network/models/notification.dart' as model;

class NotificationTile extends ConsumerWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallete.tealColor,
            )
          : notification.notificationType == NotificationType.like
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                )
              : notification.notificationType == NotificationType.reply
                  ? const Icon(
                      Icons.message,
                      color: Pallete.tealColor,
                      size: 20,
                    )
                  : null,
      title: Text(notification.text),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => showOptions(context, ref),
      ),
    );
  }

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
        height: 50,
        child: ListView(
          children: [
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(Icons.delete, color:Colors.red),
              title: const Text('Delete'),
              onTap: () {
                ref.read(notificationControllerProvider.notifier).deleteNotification(notification.id);            },
            ),
          ],
        ),
      ),
    );
  }
}
