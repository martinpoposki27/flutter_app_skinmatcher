// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
// class NotificationAPI {
//   static final _localNotificationService = FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('ic_launcher');
//     final InitializationSettings settings = InitializationSettings(android: androidInitializationSettings);
//     await _localNotificationService.initialize(settings, onSelectNotification: onSelectedNotification);
//   }
//
//   void onSelectedNotification (String? payload) {
//     print(payload);
//   }
//
//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         channelDescription: 'channel description',
//         importance: Importance.max,
//         icon: "", //<-- Add this parameter
//       ),
//       //iOS: IOSNotificationDetails(),
//     );
//   }
//
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     final details = await _notificationDetails();
//     await _localNotificationService.show(id, title, body, details);
//   }
//
// }