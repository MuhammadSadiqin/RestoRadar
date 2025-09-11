import 'package:flutter/material.dart';
import 'package:resto_radar/data/local/local_database_service.dart';
import 'package:resto_radar/data/model/restaurant.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<Restaurant>? _restaurantList;
  List<Restaurant>? get restaurantList => _restaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Clear message setelah beberapa waktu
  void _clearMessage() {
    Future.delayed(const Duration(seconds: 3), () {
      _message = "";
      notifyListeners();
    });
  }

  Future<void> saveRestaurant(Restaurant value) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _service.insertRestaurant(value);

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
      } else {
        _message = "Your data is saved";
        // Otomatis refresh list setelah save
        await loadAllRestaurant();
      }
    } catch (e) {
      _message = "Failed to save your data";
    } finally {
      _isLoading = false;
      notifyListeners();
      _clearMessage();
    }
  }

  Future<void> loadAllRestaurant() async {
    try {
      _isLoading = true;
      notifyListeners();

      _restaurantList = await _service.getAllRestaurants();
      _restaurant = null;
      _message = "All of your data is loaded";
    } catch (e) {
      _message = "Failed to load your all data";
    } finally {
      _isLoading = false;
      notifyListeners();
      _clearMessage();
    }
  }

  Future<void> loadRestaurantById(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      _restaurant = await _service.getRestaurantById(id);
      _message = "Your data is loaded";
    } catch (e) {
      _message = "Failed to load your data";
    } finally {
      _isLoading = false;
      notifyListeners();
      _clearMessage();
    }
  }

  Future<void> removeRestaurantById(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _service.removeRestaurant(id);
      _message = "Your data is removed";

      // Refresh list setelah remove
      await loadAllRestaurant();
    } catch (e) {
      _message = "Failed to remove your data";
    } finally {
      _isLoading = false;
      notifyListeners();
      _clearMessage();
    }
  }

  bool checkItemBookmark(String id) {
    // Cek apakah ada di list favorites
    return _restaurantList?.any((restaurant) => restaurant.id == id) ?? false;
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (checkItemBookmark(restaurant.id)) {
      await removeRestaurantById(restaurant.id);
      _message = '${restaurant.name} dihapus dari favorit';
    } else {
      await saveRestaurant(restaurant);
      _message = '${restaurant.name} ditambahkan ke favorit';
    }
    notifyListeners();

    // Clear message setelah beberapa waktu
    Future.delayed(const Duration(seconds: 3), () {
      _message = "";
      notifyListeners();
    });
  }
}
