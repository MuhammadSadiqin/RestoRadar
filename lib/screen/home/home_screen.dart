import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/provider/home/restaurant_list_provider.dart';
import 'package:resto_radar/screen/home/restaurant_list_view.dart';
import 'package:resto_radar/static/navigation_route.dart';
import 'package:resto_radar/static/result_state.dart';
import 'package:resto_radar/widget/custom_error_widget.dart';
import 'package:resto_radar/widget/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RestaurantListProvider>().fetchRestaurants();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RestoRadar'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NavigationRoute.searchRoute.name);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            LoadingState() => const LoadingWidget(),
            SuccessState(data: final response) => RestaurantListView(
              restaurants: response.restaurants,
              onRefresh: () => provider.fetchRestaurants(),
            ),
            ErrorState(message: final error) => CustomErrorWidget(
              message: error,
              onRetry: _loadData,
            ),
            _ => const Center(child: Text('Tidak ada data')),
          };
        },
      ),
    );
  }
}
