import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resto_radar/data/model/restaurant_list_response.dart';
import 'package:resto_radar/data/model/restaurant_detail_response.dart';
import 'package:resto_radar/data/model/restaurant_search_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _imageBaseUrl =
      'https://restaurant-api.dicoding.dev/images/';

  static String getSmallImage(String pictureId) =>
      '${_imageBaseUrl}small/$pictureId';
  static String getMediumImage(String pictureId) =>
      '${_imageBaseUrl}medium/$pictureId';
  static String getLargeImage(String pictureId) =>
      '${_imageBaseUrl}large/$pictureId';

  Future<RestaurantListResponse> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}list'));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response.statusCode, 'memuat data restoran');
      }
    } catch (e) {
      throw _handleException(e, 'memuat data restoran');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}detail/$id'));

      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response.statusCode, 'memuat detail restoran');
      }
    } catch (e) {
      throw _handleException(e, 'memuat detail restoran');
    }
  }

  Future<RestaurantSearchResponse> searchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}search?q=$query'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final originalResponse = RestaurantSearchResponse.fromJson(
          jsonResponse,
        );
        final filteredRestaurants = originalResponse.restaurants.where((
          restaurant,
        ) {
          final searchQuery = query.toLowerCase();
          return restaurant.name.toLowerCase().contains(searchQuery);
        }).toList();

        return RestaurantSearchResponse(
          error: false,
          founded: filteredRestaurants.length,
          restaurants: filteredRestaurants,
        );
      } else {
        throw _handleError(response.statusCode, 'mencari restoran');
      }
    } catch (e) {
      throw _handleException(e, 'mencari restoran');
    }
  }

  Future<RestaurantDetailResponse> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'name': name, 'review': review}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return await getRestaurantDetail(id);
      } else {
        throw _handleError(response.statusCode, 'mengirim ulasan');
      }
    } catch (e) {
      throw _handleException(e, 'mengirim ulasan');
    }
  }

  String _handleError(int statusCode, String action) {
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid. Silakan coba lagi.';
      case 401:
        return 'Akses ditolak. Silakan login terlebih dahulu.';
      case 403:
        return 'Anda tidak memiliki izin untuk $action.';
      case 404:
        return 'Data tidak ditemukan.';
      case 408:
        return 'Waktu permintaan habis. Silakan coba lagi.';
      case 500:
        return 'Server mengalami gangguan. Silakan coba lagi nanti.';
      case 503:
        return 'Layanan tidak tersedia. Silakan coba lagi nanti.';
      default:
        return 'Gagal $action. Kode error: $statusCode';
    }
  }

  String _handleException(dynamic exception, String action) {
    final error = exception.toString();

    if (error.contains('SocketException') ||
        error.contains('Network is unreachable') ||
        error.contains('Failed host lookup')) {
      return 'Tidak dapat terhubung ke internet. Silakan periksa koneksi Anda.';
    } else if (error.contains('Timeout') ||
        error.contains('Connection timed out')) {
      return 'Waktu koneksi habis. Pastikan koneksi internet Anda stabil.';
    } else if (error.contains('HandshakeException')) {
      return 'Gagal terhubung ke server. Silakan coba lagi nanti.';
    } else {
      return 'Terjadi kesalahan saat $action. Silakan coba lagi.';
    }
  }
}
