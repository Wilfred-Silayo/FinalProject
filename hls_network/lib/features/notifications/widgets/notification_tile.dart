import 'package:flutter/material.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/enums/notification_type.dart';
import 'package:hls_network/models/notification.dart' as model;


class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
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
              :notification.notificationType == NotificationType.reply
              ? const Icon(
                  Icons.message,
                  color: Pallete.tealColor,
                  size: 20,
                )
              : null,
      title: Text(notification.text),
    );
  }
}
