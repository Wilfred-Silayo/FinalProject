import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hls_network/features/auth/controllers/auth_controller.dart';
// import 'package:hls_network/features/notifications/controller/notification_controller.dart';
// import 'package:hls_network/features/notifications/widgets/notification_tile.dart';
// import 'package:hls_network/utils/error_page.dart';
// import 'package:hls_network/utils/loading_page.dart';
// import 'package:hls_network/models/notification.dart' as model;

// class NotificationView extends ConsumerWidget {
//   const NotificationView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(currentUserDetailsProvider).value;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: currentUser == null
//           ? const Loader()
//           : ref.watch(getNotificationsProvider(currentUser.uid)).when(
//                 data: (notifications) {
//                   return ref.watch(getLatestNotificationProvider).when(
//                         data: (data) {
//                           final latestNotif = model.Notification.fromMap(
//                               data.docs.last.data() as Map<String, dynamic>);
//                           if (latestNotif.uid == currentUser.uid) {
//                             notifications.insert(0, latestNotif);
//                           }

//                           return ListView.builder(
//                             itemCount: notifications.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               final notification = notifications[index];
//                               return NotificationTile(
//                                 notification: notification,
//                               );
//                             },
//                           );
//                         },
//                         error: (error, stackTrace) => ErrorText(
//                           error: error.toString(),
//                         ),
//                         loading: () {
//                           return ListView.builder(
//                             itemCount: notifications.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               final notification = notifications[index];
//                               return NotificationTile(
//                                 notification: notification,
//                               );
//                             },
//                           );
//                         },
//                       );
//                 },
//                 error: (error, stackTrace) => ErrorText(
//                   error: error.toString(),
//                 ),
//                 loading: () => const Loader(),
//               ),
//     );
//   }
// }

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
