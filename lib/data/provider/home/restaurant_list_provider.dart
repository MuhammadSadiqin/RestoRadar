import 'package:flutter/material.dart';
import 'package:resto_radar/data/api/api_services.dart';
import 'package:resto_radar/data/model/restaurant_list_response.dart';
import 'package:resto_radar/static/result_state.dart';

class RestaurantListProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService});

  ResultState<RestaurantListResponse> _state = InitialState();
  ResultState<RestaurantListResponse> get state => _state;

  Future<void> fetchRestaurants() async {
    _state = LoadingState();
    notifyListeners();

    try {
      final restaurants = await apiService.getRestaurants();
      _state = SuccessState(restaurants);
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
