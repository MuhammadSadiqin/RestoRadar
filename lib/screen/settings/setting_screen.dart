import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/provider/reminder/reminder_provider.dart';
import 'package:resto_radar/data/provider/theme/theme_provider.dart';
import 'package:resto_radar/widget/theme_option_card.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final reminderProvider = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION: THEME SETTINGS
            Text(
              'Tema',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Light Theme Option
            ThemeOptionCard(
              title: 'Light Theme',
              subtitle: 'Tema terang',
              icon: Icons.light_mode,
              isSelected: themeProvider.isLightMode,
              onTap: () => themeProvider.setThemeMode(ThemeMode.light),
            ),

            const SizedBox(height: 12),

            // Dark Theme Option
            ThemeOptionCard(
              title: 'Dark Theme',
              subtitle: 'Tema gelap',
              icon: Icons.dark_mode,
              isSelected: themeProvider.isDarkMode,
              onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
            ),

            const SizedBox(height: 12),

            // System Theme Option
            ThemeOptionCard(
              title: 'System Default',
              subtitle: 'Ikuti pengaturan sistem',
              icon: Icons.settings,
              isSelected: themeProvider.isSystemMode,
              onTap: () => themeProvider.setThemeMode(ThemeMode.system),
            ),

            const SizedBox(height: 32),

            // SECTION: REMINDER SETTINGS
            Text(
              'Pengingat',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Reminder Toggle Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Reminder',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Notifikasi pukul 11:00 setiap hari',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: reminderProvider.isReminderEnabled,
                      onChanged: (value) async {
                        await reminderProvider.toggleReminder(value);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Reminder Information Card
            Card(
              elevation: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Anda akan menerima notifikasi setiap hari pukul 11:00 '
                        'sebagai pengingat untuk makan siang yang sehat.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
