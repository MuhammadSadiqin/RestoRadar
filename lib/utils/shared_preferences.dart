import 'package:shared_preferences/shared_preferences.dart';

class ReminderPreferences {
  static const String _reminderKey = 'daily_reminder_enabled';

  Future<bool> getReminder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reminderKey) ?? false;
  }

  Future<void> setReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderKey, value);
  }
}
