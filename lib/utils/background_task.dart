import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resto_radar/data/api/api_services.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notifications = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await notifications.initialize(
      const InitializationSettings(android: androidInit),
    );

    final api = ApiService();
    String name = 'Your Favorite Restaurant';
    try {
      final data = await api.getRestaurants();
      final list = data.restaurants;
      if (list.isNotEmpty) {
        list.shuffle();
        name = list.first.name;
      }
    } catch (_) {}

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder',
      channelDescription: 'Reminder for lunch',
      importance: Importance.max,
      priority: Priority.high,
    );

    await notifications.show(
      1001,
      'Time to lunch!',
      'Try to eat at: $name 🍽️',
      const NotificationDetails(android: androidDetails),
    );

    return Future.value(true);
  });
}
