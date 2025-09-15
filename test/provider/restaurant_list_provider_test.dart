import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resto_radar/data/api/api_services.dart';
import 'package:resto_radar/data/model/restaurant.dart';
import 'package:resto_radar/data/model/restaurant_list_response.dart';
import 'package:resto_radar/data/provider/home/restaurant_list_provider.dart';
import 'package:resto_radar/static/result_state.dart';

@GenerateMocks([ApiService])
import 'restaurant_list_provider_test.mocks.dart';

void main() {
  late MockApiService mockApiService;
  late RestaurantListProvider provider;

  setUp(() {
    mockApiService = MockApiService();
    provider = RestaurantListProvider(apiService: mockApiService);
  });

  group('RestaurantListProvider Tests', () {
    // Test 1: Memastikan state awal provider harus didefinisikan
    test('Initial state should be InitialState', () {
      // Assert
      expect(provider.state, isA<InitialState>());
    });

    // Test 2: Memastikan harus mengembalikan daftar restoran ketika pengambilan data API berhasil
    test('Should return restaurant list when API call is successful', () async {
      // Arrange
      final mockResponse = RestaurantListResponse(
        error: false,
        message: 'success',
        count: 2,
        restaurants: [
          Restaurant(
            id: '1',
            name: 'Test Restaurant 1',
            description: 'Test Description 1',
            pictureId: 'img1',
            city: 'Test City 1',
            rating: 4.5,
          ),
          Restaurant(
            id: '2',
            name: 'Test Restaurant 2',
            description: 'Test Description 2',
            pictureId: 'img2',
            city: 'Test City 2',
            rating: 4.0,
          ),
        ],
      );

      when(
        mockApiService.getRestaurants(),
      ).thenAnswer((_) async => mockResponse);

      // Act
      await provider.fetchRestaurants();

      // Assert
      expect(provider.state, isA<SuccessState>());
      final successState = provider.state as SuccessState;
      expect(successState.data, mockResponse);
      expect(successState.data.restaurants.length, 2);
      expect(successState.data.restaurants[0].name, 'Test Restaurant 1');
      expect(successState.data.restaurants[1].name, 'Test Restaurant 2');
    });

    // Test 3: Memastikan harus mengembalikan kesalahan ketika pengambilan data API gagal
    test('Should return error when API call fails', () async {
      // Arrange
      when(
        mockApiService.getRestaurants(),
      ).thenThrow(Exception('Network error'));

      // Act
      await provider.fetchRestaurants();

      // Assert
      expect(provider.state, isA<ErrorState>());
      final errorState = provider.state as ErrorState;
      expect(errorState.message, contains('Network error'));
    });

    // Test 4: Memastikan error handling untuk berbagai jenis exception
    test('Should handle different types of exceptions', () async {
      // Arrange
      when(mockApiService.getRestaurants()).thenThrow('String exception');

      // Act
      await provider.fetchRestaurants();

      // Assert
      expect(provider.state, isA<ErrorState>());
      final errorState = provider.state as ErrorState;
      expect(errorState.message, contains('String exception'));
    });

    // Test 5: Memastikan empty restaurant list handling
    test('Should handle empty restaurant list', () async {
      // Arrange
      final mockResponse = RestaurantListResponse(
        error: false,
        message: 'success',
        count: 0,
        restaurants: [],
      );

      when(
        mockApiService.getRestaurants(),
      ).thenAnswer((_) async => mockResponse);

      // Act
      await provider.fetchRestaurants();

      // Assert
      expect(provider.state, isA<SuccessState>());
      final successState = provider.state as SuccessState;
      expect(successState.data.restaurants.isEmpty, true);
    });
  });
}
