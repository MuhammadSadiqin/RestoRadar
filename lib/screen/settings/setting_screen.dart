import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/provider/theme/theme_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

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
            Text('Pilih Tema', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

            // Light Theme Option
            _ThemeOptionCard(
              title: 'Light Theme',
              subtitle: 'Tema terang',
              icon: Icons.light_mode,
              isSelected: themeProvider.isLightMode,
              onTap: () => themeProvider.setThemeMode(ThemeMode.light),
            ),

            const SizedBox(height: 12),

            // Dark Theme Option
            _ThemeOptionCard(
              title: 'Dark Theme',
              subtitle: 'Tema gelap',
              icon: Icons.dark_mode,
              isSelected: themeProvider.isDarkMode,
              onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
            ),

            const SizedBox(height: 12),

            // System Theme Option
            _ThemeOptionCard(
              title: 'System Default',
              subtitle: 'Ikuti pengaturan sistem',
              icon: Icons.settings,
              isSelected: themeProvider.isSystemMode,
              onTap: () => themeProvider.setThemeMode(ThemeMode.system),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).iconTheme.color,
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
