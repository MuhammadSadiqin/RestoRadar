import 'package:flutter/material.dart';
import 'package:resto_radar/data/model/restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Restaurant> _favoriteRestaurants = [];

  List<Restaurant> get favoriteRestaurants => _favoriteRestaurants;

  bool isFavorite(String restaurantId) {
    return _favoriteRestaurants.any((r) => r.id == restaurantId);
  }

  void addFavorite(Restaurant restaurant) {
    if (!isFavorite(restaurant.id)) {
      _favoriteRestaurants.add(restaurant);
      notifyListeners();
    }
  }

  void removeFavorite(String restaurantId) {
    _favoriteRestaurants.removeWhere(
      (restaurant) => restaurant.id == restaurantId,
    );
    notifyListeners();
  }

  void toggleFavorite(Restaurant restaurant) {
    if (isFavorite(restaurant.id)) {
      removeFavorite(restaurant.id);
    } else {
      addFavorite(restaurant);
    }
  }
}
