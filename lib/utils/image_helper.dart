class ImageHelper {
  static const String _imageBaseUrl =
      'https://restaurant-api.dicoding.dev/images/';

  static String getSmallImage(String pictureId) {
    return '${_imageBaseUrl}small/$pictureId';
  }

  static String getMediumImage(String pictureId) {
    return '${_imageBaseUrl}medium/$pictureId';
  }

  static String getLargeImage(String pictureId) {
    return '${_imageBaseUrl}large/$pictureId';
  }

  // Fallback image jika needed
  static String get fallbackImage => '${_imageBaseUrl}medium/placeholder';
}
