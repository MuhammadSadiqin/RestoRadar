import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:resto_radar/data/api/api_services.dart';
import 'package:resto_radar/utils/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

class ReminderProvider with ChangeNotifier {
  bool _isReminderEnabled = false;
  static const _workname = 'daily_restaurant';
  final ReminderPreferences _preferences = ReminderPreferences();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ApiService _apiService;

  bool get isReminderEnabled => _isReminderEnabled;

  FlutterLocalNotificationsPlugin get notificationsPlugin =>
      _notificationsPlugin;

  ReminderProvider(this._apiService) {
    _initializeNotification();
    _loadReminder();
  }

  Future<void> _initializeNotification() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool> _requestAndroidNotificationsPermission() async {
    return await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final notificationEnabled = await _isAndroidPermissionGranted();
      if (!notificationEnabled) {
        final requestNotificationsPermission =
            await _requestAndroidNotificationsPermission();
        return requestNotificationsPermission;
      }
      return notificationEnabled;
    } else {
      return false;
    }
  }

  Future<void> toggleReminder(bool isEnabled) async {
    if (isEnabled) {
      final granted = await requestPermissions() ?? false;
      if (!granted) {
        _isReminderEnabled = false;
        await _preferences.setReminder(false);
        notifyListeners();
        return;
      }
    }

    _isReminderEnabled = isEnabled;
    await _preferences.setReminder(isEnabled);
    notifyListeners();

    if (isEnabled) {
      await _registerDailyWorkAt11();
    } else {
      await _notificationsPlugin.cancel(0);
      await Workmanager().cancelByUniqueName(_workname);
    }
  }

  Future<void> _loadReminder() async {
    _isReminderEnabled = await _preferences.getReminder();

    if (_isReminderEnabled) {
      final granted = await requestPermissions() ?? false;
      if (!granted) {
        _isReminderEnabled = false;
        await _preferences.setReminder(false);
      } else {
        await _scheduleDailyReminder();
      }
    }

    notifyListeners();
  }

  Future<void> _scheduleDailyReminder() async {
    final restaurantName = await _getRandomRestaurantName();

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder',
      channelDescription: 'Reminder for lucnh',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      0,
      'Time to launch!',
      'Try to eat at: $restaurantName 🍽️',
      _nextInstanceOf11AM(),
      notificationDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  Future<void> _registerDailyWorkAt11() async {
    final delay = _delayUntilNext11();
    await Workmanager().registerPeriodicTask(
      _workname,
      'dailyRestaurantTask',
      frequency: const Duration(days: 1),
      initialDelay: delay,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  tz.TZDateTime _nextInstanceOf11AM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      11,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Duration _delayUntilNext11() {
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, 11);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    return target.difference(now);
  }

  Future<String> _getRandomRestaurantName() async {
    try {
      final response = await _apiService.getRestaurants();
      final restaurants = response.restaurants;
      if (restaurants.isNotEmpty) {
        final random = restaurants[Random().nextInt(restaurants.length)];
        return random.name;
      }
    } catch (_) {}
    return 'Restoran favoritmu';
  }
}
