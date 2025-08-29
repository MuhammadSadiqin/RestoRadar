import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/api/api_services.dart';
import 'package:resto_radar/data/provider/detail/restaurant_detail_provider.dart';
import 'package:resto_radar/data/provider/favorite/favorite_provider.dart';
import 'package:resto_radar/data/provider/home/restaurant_list_provider.dart';
import 'package:resto_radar/data/provider/main/bottom_nav_provider.dart';
import 'package:resto_radar/data/provider/restaurant_search_provider.dart';
import 'package:resto_radar/screen/detail/detail_screen.dart';
import 'package:resto_radar/screen/home/search_screen.dart';
import 'package:resto_radar/screen/main/main_screen.dart';
import 'package:resto_radar/static/navigation_route.dart';
import 'package:resto_radar/utils/theme.dart';

void main() {
  runApp(const RestoRadarApp());
}

class RestoRadarApp extends StatelessWidget {
  const RestoRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (_) => BottomNavProvider(),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<RestaurantListProvider>(
          create: (context) =>
              RestaurantListProvider(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (context) =>
              RestaurantDetailProvider(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider<RestaurantSearchProvider>(
          create: (context) =>
              RestaurantSearchProvider(apiService: context.read<ApiService>()),
        ),
      ],
      child: MaterialApp(
        title: 'RestoRadar',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        initialRoute: NavigationRoute.mainRoute.name,
        routes: {
          NavigationRoute.mainRoute.name: (context) => const MainScreen(),
          NavigationRoute.detailRoute.name: (context) {
            final arguments = ModalRoute.of(context)!.settings.arguments;
            if (arguments is String) {
              return DetailScreen(restaurantId: arguments);
            }
            return const Scaffold(
              body: Center(child: Text('Restaurant ID tidak valid')),
            );
          },
          NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
