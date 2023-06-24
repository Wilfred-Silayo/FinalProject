import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hls_network/models/notification.dart';
import 'package:hls_network/providers/firebase_providers.dart';
import 'package:hls_network/utils/failure.dart';
import 'package:hls_network/utils/type_defs.dart';


final notificationAPIProvider = Provider((ref) {
  return NotificationAPI(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

abstract class INotificationAPI {
  FutureEitherVoid createNotification(Notification notification);
  Future<List<DocumentSnapshot>> getNotifications(String uid);
  Stream<QuerySnapshot> getLatestNotification();
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
          .add(notification.toMap());
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
  Future<List<DocumentSnapshot>> getNotifications(String uid) async {
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('uid', isEqualTo: uid)
        .get();
    return querySnapshot.docs;
  }

  @override
  Stream<QuerySnapshot> getLatestNotification() {
    return _firestore
        .collection('notifications')
        .snapshots();
  }
}
