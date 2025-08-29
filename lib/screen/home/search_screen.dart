import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/model/restaurant_search_response.dart';
import 'package:resto_radar/data/provider/restaurant_search_provider.dart';
import 'package:resto_radar/screen/home/restaurant_card.dart';
import 'package:resto_radar/static/result_state.dart';
import 'package:resto_radar/widget/custom_error_widget.dart';
import 'package:resto_radar/widget/loading_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late RestaurantSearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _searchProvider = context.read<RestaurantSearchProvider>();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      _searchProvider.searchRestaurants(query);
    } else {
      _searchProvider.resetState();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchProvider.resetState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari Restoran"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Restoran.....',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _clearSearch();
                  },
                  icon: const Icon(Icons.clear),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: _performSearch,
              onSubmitted: _performSearch,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Consumer<RestaurantSearchProvider>(
                builder: (context, provider, child) {
                  if (provider.state is LoadingState &&
                      _searchController.text.isNotEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return switch (provider.state) {
                    LoadingState() => const LoadingWidget(),
                    SuccessState(data: final response) => _buildSearchResults(
                      response,
                    ),
                    ErrorState(message: final error) => CustomErrorWidget(
                      message: error,
                      onRetry: () => _performSearch(_searchController.text),
                    ),
                    _ => _buildInitialState(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Cari Restoran Favorit Kamu',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(RestaurantSearchResponse response) {
    if (response.restaurants.isEmpty) {
      return const Center(child: Text("Tidak ada Restorran yang ditemukan"));
    }

    return ListView.builder(
      itemCount: response.restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = response.restaurants[index];
        return RestaurantCard(restaurant: restaurant);
      },
    );
  }
}
