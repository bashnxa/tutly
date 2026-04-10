import 'package:flutter/material.dart';
import 'package:tutly/models/place.dart';
import 'package:tutly/models/category.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final Category category;
  final VoidCallback? onTap;
  final VoidCallback? onMapTap;

  const PlaceCard({
    super.key,
    required this.place,
    required this.category,
    this.onTap,
    this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder with gradient overlay
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getCategoryGradient(category.id),
                ),
              ),
              child: Stack(
                children: [
                  // Category badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildCategoryBadge(theme),
                  ),
                  // Distance badge (if available)
                  if (place.distance != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _buildDistanceBadge(theme),
                    ),
                  // Center content (placeholder for image)
                  Center(
                    child: Icon(
                      _getCategoryIcon(category.id),
                      size: 64,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    place.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    place.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Map button
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onMapTap,
                          icon: const Icon(Icons.map_outlined, size: 18),
                          label: const Text('На карте'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(category.id),
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            category.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceBadge(ThemeData theme) {
    final distanceText = Place.formatDistance(place.distance!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            distanceText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'sight':
        return Icons.landscape_outlined;
      case 'food':
        return Icons.restaurant_outlined;
      case 'walk':
        return Icons.directions_walk_outlined;
      case 'photo':
        return Icons.camera_alt_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  List<Color> _getCategoryGradient(String categoryId) {
    switch (categoryId) {
      case 'sight':
        return [Color(0xFF667eea), Color(0xFF764ba2)];
      case 'food':
        return [Color(0xFFf093fb), Color(0xFFf5576c)];
      case 'walk':
        return [Color(0xFF4facfe), Color(0xFF00f2fe)];
      case 'photo':
        return [Color(0xFFfa709a), Color(0xFFfee140)];
      default:
        return [Color(0xFFa18cd1), Color(0xFFfbc2eb)];
    }
  }
}