import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hls_network/Apis/notification_api.dart';
import 'package:hls_network/utils/enums/notification_type.dart';
import 'package:hls_network/models/notification.dart'as model;
import 'package:uuid/uuid.dart';


final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>((ref) {
  return NotificationController(
    notificationAPI: ref.watch(notificationAPIProvider),
  );
});

final getNotificationProvider = StreamProvider.family((ref, String uid) {
  final notification = ref.watch(notificationControllerProvider.notifier);
  return notification.getNotifications(uid);
});


class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController({required NotificationAPI notificationAPI})
      : _notificationAPI = notificationAPI,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
     String id = const Uuid().v1();
    final notification = model.Notification(
      text: text,
      postId: postId,
      createdAt: DateTime.now(),
      id: id,
      uid: uid,
      notificationType: notificationType,
    );
    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => null, (r) => null);
  }

  Stream<List<model.Notification>> getNotifications(String uid) {
    return _notificationAPI.getNotifications(uid);
  }

  void deleteNotification(String notificationId) async {
  final res = await _notificationAPI.deleteNotification(notificationId);
  res.fold((l) => null, (r) => null);
}

}
