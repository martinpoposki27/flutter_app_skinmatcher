import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationsService{
  LocalNotificationsService();

  final _localNotificationsService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidRecieveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationsService.initialize(
      settings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }

  Future<NotificationDetails> _notificationDetails() async{
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails,
        iOS:iosNotificationDetails);
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationsService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification({required int id, required String title, required String body, required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationsService.zonedSchedule(
      0,
      title,
      "Event upcoming!",
      tz.TZDateTime.from(DateTime.now().add(Duration(seconds: seconds)), tz.local,),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _onDidRecieveLocalNotification(int id, String? title, String? body, String? payload){
    print('id $id');
  }

  void onSelectNotification(NotificationResponse details) {
    print('payload $details');
  }
}