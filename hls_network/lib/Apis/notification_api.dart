import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hls_network/models/notification.dart';
import 'package:hls_network/providers/firebase_providers.dart';
import 'package:hls_network/utils/failure.dart';
import 'package:hls_network/utils/type_defs.dart';
import 'package:hls_network/models/notification.dart' as model;

final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
  Stream<List<model.Notification>> getNotifications(String uid);
  FutureEitherVoid deleteNotification(String notificationId);
}

class NotificationAPI implements INotificationAPI {
  final FirebaseFirestore _firestore;
  NotificationAPI({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  FutureEitherVoid createNotification(Notification notification) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toMap());
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
      return right(null);
    } on FirebaseException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Stream<List<model.Notification>> getNotifications(String uid) {
    return _firestore
        .collection('notifications')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => model.Notification.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
