import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/provider/detail/restaurant_detail_provider.dart';
import 'package:resto_radar/screen/detail/detail_content.dart';
import 'package:resto_radar/static/result_state.dart';
import 'package:resto_radar/widget/custom_error_widget.dart';
import 'package:resto_radar/widget/loading_widget.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;
  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
          widget.restaurantId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, child) {
            return switch (provider.state) {
              LoadingState() => const LoadingWidget(),
              SuccessState(data: final restaurant) => DetailContent(
                restaurant: restaurant,
              ),
              ErrorState(message: final error) => CustomErrorWidget(
                message: error,
                onRetry: _loadData,
              ),
              _ => const Center(child: Text('Data TIdak ditemukan')),
            };
          },
        ),
      ),
    );
  }
}
