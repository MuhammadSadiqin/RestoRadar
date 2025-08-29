import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/provider/favorite/favorite_provider.dart';
import 'package:resto_radar/screen/home/restaurant_card.dart';
import 'package:resto_radar/utils/theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.secondaryColor,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final favorites = favoriteProvider.favoriteRestaurants;

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada restaurant favorit',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final restaurant = favorites[index];
              return RestaurantCard(restaurant: restaurant);
            },
          );
        },
      ),
    );
  }
}
