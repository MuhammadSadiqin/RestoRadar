import 'package:flutter/material.dart';
import 'package:resto_radar/data/api/api_services.dart';
import 'package:resto_radar/data/model/restaurant.dart';
import 'package:resto_radar/static/result_state.dart';

class RestaurantDetailProvider with ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  ResultState<Restaurant> _state = InitialState();
  ResultState<Restaurant> get state => _state;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = LoadingState();
    notifyListeners();

    try {
      final response = await apiService.getRestaurantDetail(id);
      _state = SuccessState(response.restaurant);
    } catch (e) {
      _state = ErrorState(e.toString());
    }
    notifyListeners();
  }

  Future<bool> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final previousState = _state;

    try {
      _state = LoadingState();
      notifyListeners();

      final response = await apiService.postReview(
        id: id,
        name: name,
        review: review,
      );

      _state = SuccessState(response.restaurant);
      notifyListeners();

      return true; // Success
    } catch (e) {
      _state = previousState;
      notifyListeners();

      return false; // Failure
    }
  }

  void resetState() {
    _state = InitialState();
    notifyListeners();
  }
}
