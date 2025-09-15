import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resto_radar/data/model/restaurant.dart';
import 'package:resto_radar/data/provider/favorite/local_database_provider.dart';
import 'package:resto_radar/utils/image_helper.dart';
import 'package:resto_radar/utils/theme.dart';
import 'package:resto_radar/widget/review_card.dart';
import 'package:resto_radar/widget/review_form.dart';

class DetailContent extends StatefulWidget {
  final Restaurant restaurant;
  const DetailContent({super.key, required this.restaurant});

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image dengan Stack
          Stack(
            children: [
              Hero(
                tag: 'restaurant-${widget.restaurant.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    ImageHelper.getLargeImage(widget.restaurant.pictureId),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.restaurant,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Back Button
              Positioned(
                top: 16,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),

              // Favorite Button
              Positioned(
                top: 16,
                right: 16,
                child: Consumer<LocalDatabaseProvider>(
                  builder: (context, provider, child) {
                    final isFavorite = provider.checkItemBookmark(
                      widget.restaurant.id,
                    );
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          provider.toggleFavorite(widget.restaurant);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? '${widget.restaurant.name} dihapus dari favorit'
                                    : '${widget.restaurant.name} ditambahkan ke favorit',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Restaurant Name dan Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.restaurant.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    widget.restaurant.rating.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          //city
          Row(
            children: [
              const Icon(Icons.location_city, color: Colors.grey, size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.restaurant.city,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Address
          if (widget.restaurant.address != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 20),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.restaurant.address!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 8),

          // Categories
          if (widget.restaurant.categories != null &&
              widget.restaurant.categories!.isNotEmpty) ...[
            const Text(
              'Kategori:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.restaurant.categories!
                  .map(
                    (category) => Chip(
                      label: Text(category.name),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.restaurant.description,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: _isExpanded ? null : 3,
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
              if (widget.restaurant.description.length >
                  150) // Hanya tampilkan tombol jika deskripsi panjang
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Sembunyikan' : 'Baca selengkapnya',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Menus - Foods
          if (widget.restaurant.menu != null) ...[
            Text(
              'Menu Makanan:',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.restaurant.menu!.foods
                    .map(
                      (food) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(food.name),
                          backgroundColor: AppTheme.secondaryColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Menus - Drinks
            Text(
              'Menu Minuman:',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.restaurant.menu!.drinks
                    .map(
                      (drink) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(drink.name),
                          backgroundColor: AppTheme.secondaryColor,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Reviews Header dengan Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ulasan Pelanggan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 24),
                onPressed: () =>
                    _showAddReviewDialog(context, widget.restaurant.id),
                tooltip: 'Tambah Ulasan',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reviews List
          if (widget.restaurant.customerReviews != null &&
              widget.restaurant.customerReviews!.isNotEmpty) ...[
            ...widget.restaurant.customerReviews!.map(
              (review) => ReviewCard(review: review),
            ),
          ] else ...[
            const Center(
              child: Text(
                'Belum ada ulasan untuk restoran ini',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context, String restaurantId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ReviewForm(
              restaurantId: restaurantId,
              onSuccess: () => Navigator.pop(context),
              onCancel: () => Navigator.pop(context),
            ),
          ),
        );
      },
    );
  }
}
