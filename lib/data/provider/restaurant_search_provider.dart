import 'package:flutter/material.dart';
import 'package:resto_radar/data/api/api_services.dart';
import 'package:resto_radar/data/model/restaurant_search_response.dart';
import 'package:resto_radar/static/result_state.dart';

class RestaurantSearchProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService});

  ResultState<RestaurantSearchResponse> _state = InitialState();
  ResultState<RestaurantSearchResponse> get state => _state;

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _state = InitialState();
      notifyListeners();
      return;
    }

    _state = LoadingState();
    notifyListeners();

    try {
      final results = await apiService.searchRestaurants(query);
      _state = SuccessState(results);
    } catch (e) {
      _state = ErrorState(e.toString());
    }
    notifyListeners();
  }

  void resetState() {
    _state = InitialState();
    notifyListeners();
  }
}
