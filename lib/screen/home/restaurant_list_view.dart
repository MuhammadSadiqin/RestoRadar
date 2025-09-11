import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/model/restaurant.dart';
import 'package:resto_radar/data/provider/favorite/local_database_provider.dart';
import 'package:resto_radar/screen/home/restaurant_card.dart';

class RestaurantListView extends StatelessWidget {
  final List<Restaurant> restaurants;
  final Future<void> Function() onRefresh;

  const RestaurantListView({
    super.key,
    required this.restaurants,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDatabaseProvider>(
      builder: (context, favoriteProvider, child) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(restaurant: restaurant);
            },
          ),
        );
      },
    );
  }
}
