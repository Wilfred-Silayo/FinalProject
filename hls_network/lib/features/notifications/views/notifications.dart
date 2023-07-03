import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/features/auth/controllers/auth_controller.dart';
import 'package:hls_network/features/notifications/controller/notification_controller.dart';
import 'package:hls_network/themes/themes_helper.dart';
import 'package:hls_network/utils/enums/notification_type.dart';
import 'package:hls_network/utils/error_page.dart';
import 'package:hls_network/utils/loading_page.dart';

class NotificationView extends ConsumerStatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends ConsumerState<NotificationView> {
  List<String> selectedNotifications = [];

  void _deleteSelectedNotifications() {
    for (String notificationId in selectedNotifications) {
      ref
          .read(notificationControllerProvider.notifier)
          .deleteNotification(notificationId);
    }

    setState(() {
      selectedNotifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (selectedNotifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteSelectedNotifications();
              },
            ),
        ],
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      final notification = notifications[index];
                      final bool isSelected =
                          selectedNotifications.contains(notification.id);
                      return ListTile(
                        leading: notification.notificationType ==
                                NotificationType.follow
                            ? const Icon(
                                Icons.person,
                                color: Pallete.tealColor,
                              )
                            : notification.notificationType ==
                                    NotificationType.like
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  )
                                : notification.notificationType ==
                                        NotificationType.reply
                                    ? const Icon(
                                        Icons.message,
                                        color: Pallete.tealColor,
                                        size: 20,
                                      )
                                    : null,
                        title: Text(notification.text),
                        onLongPress: () {
                          setState(() {
                            if (isSelected) {
                              selectedNotifications.remove(notification.id);
                            } else {
                              selectedNotifications.add(notification.id);
                            }
                          });
                        },
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
