import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/provider/main/bottom_nav_provider.dart';
import 'package:resto_radar/screen/favorite/favorites_screen.dart';
import 'package:resto_radar/screen/home/home_screen.dart';
import 'package:resto_radar/screen/settings/setting_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final List<Widget> _screen = [
    const HomeScreen(),
    const FavoritesScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          body: _screen[navProvider.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: navProvider.selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: (index) => navProvider.changeIndex(index),
            showSelectedLabels: true,
          ),
        );
      },
    );
  }
}
