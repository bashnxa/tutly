import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tutly/models/place.dart';
import 'package:tutly/models/category.dart';
import 'package:tutly/widgets/place_card.dart';
import 'package:tutly/services/location_service.dart';
import 'package:tutly/screens/map_screen.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key});

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  String? _selectedCategoryId;
  List<Category> _categories = [];
  List<Place> _places = [];
  bool _isLoading = true;
  bool _isNearbyMode = false;
  bool _isLoadingLocation = false;
  Position? _currentPosition;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _toggleNearbyMode() async {
    if (_isNearbyMode) {
      setState(() {
        _isNearbyMode = false;
        _currentPosition = null;
      });
      return;
    }

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      if (!mounted) return;
      
      print('Location received: ${position.latitude}, ${position.longitude}');
      
      setState(() {
        _currentPosition = position;
        _isNearbyMode = true;
        _isLoadingLocation = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ваше местоположение определено: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Location error: $e');
      if (!mounted) return;
      
      setState(() {
        _isLoadingLocation = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось определить местоположение: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _loadData() async {
    // In a real app, this would load from DataService
    // For now, using mock data
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _categories = _getMockCategories();
      _places = _getMockPlaces();
      _isLoading = false;
    });
  }

  List<Category> _getMockCategories() {
    return [
      Category(id: 'sight', title: 'Достопримечательности'),
      Category(id: 'food', title: 'Еда'),
      Category(id: 'walk', title: 'Прогулки'),
      Category(id: 'photo', title: 'Фото-споты'),
    ];
  }

  List<Place> _getMockPlaces() {
    return [
      Place(
        id: 1,
        name: 'Монумент Дружбы',
        categoryId: 'sight',
        lat: 54.7181,
        lng: 55.9694,
        description: 'Символ дружбы народов, панорамный вид на Белую',
        imageUrl: 'assets/images/Монумент_Дружбы.jpg',
      ),
      Place(
        id: 2,
        name: 'Салават Юлаев (памятник)',
        categoryId: 'sight',
        lat: 54.7229,
        lng: 55.9344,
        description: 'Главный символ Уфы на высоком берегу',
        imageUrl: 'assets/images/Салават_Юлаев.jpg',
      ),
      Place(
        id: 3,
        name: 'Набережная реки Белой',
        categoryId: 'walk',
        lat: 54.7212,
        lng: 55.9398,
        description: 'Лучшее место для прогулок у воды',
        imageUrl: 'assets/images/Набережная_реки_Белой.jpg',
      ),
      Place(
        id: 11,
        name: 'Кафе "Дом Башкирской кухни"',
        categoryId: 'food',
        lat: 54.7379,
        lng: 55.9602,
        description: 'Национальная башкирская кухня',
        imageUrl: 'assets/images/dom_bashkirskoy_kukhni.jpg',
      ),
      Place(
        id: 16,
        name: 'Арт-объект "Сердце Уфы"',
        categoryId: 'photo',
        lat: 54.7221,
        lng: 55.9412,
        description: 'Популярное место для фото',
        imageUrl: 'assets/images/Сердце_Уфы.jpg',
      ),
    ];
  }

  List<Place> get _filteredPlaces {
    List<Place> filteredPlaces;
    
    if (_selectedCategoryId == null) {
      filteredPlaces = List.from(_places);
    } else {
      filteredPlaces = _places.where((place) => place.categoryId == _selectedCategoryId).toList();
    }

    if (_isNearbyMode && _currentPosition != null) {
      print('Nearby mode enabled. Current position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      
      filteredPlaces = filteredPlaces.map((place) {
        final distance = Place.calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          place.lat,
          place.lng,
        );
        print('Distance to ${place.name}: ${distance.toStringAsFixed(0)}m');
        return place.copyWith(distance: distance);
      }).toList();

      filteredPlaces.sort((a, b) {
        if (a.distance == null || b.distance == null) return 0;
        return a.distance!.compareTo(b.distance!);
      });
    }

    return filteredPlaces;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openFullMap,
        icon: const Icon(Icons.map_outlined),
        label: const Text('Карта'),
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/logo_tutly.png',
                      width: 120,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image fails to load
                        return const Icon(
                          Icons.explore_outlined,
                          size: 64,
                          color: Colors.black,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Category Filter
          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ))
                : _buildCategoryFilter(theme),
          ),
          // Places List
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : _filteredPlaces.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Нет мест в этой категории',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.only(bottom: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final place = _filteredPlaces[index];
                            final category = _categories.firstWhere(
                              (cat) => cat.id == place.categoryId,
                              orElse: () => Category(id: '', title: ''),
                            );
                            return PlaceCard(
                              place: place,
                              category: category,
                              onTap: () => _showPlaceDetails(context, place, category),
                              onMapTap: () => _openMaps(place),
                            );
                          },
                          childCount: _filteredPlaces.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    return Column(
      children: [
        // Nearby button and category filters
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Nearby button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoadingLocation ? null : _toggleNearbyMode,
                  icon: _isLoadingLocation
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          _isNearbyMode ? Icons.location_on : Icons.near_me_outlined,
                        ),
                  label: Text(_isNearbyMode ? 'Рядом' : 'Рядом'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isNearbyMode
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    foregroundColor: _isNearbyMode
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    elevation: _isNearbyMode ? 4 : 1,
                    side: BorderSide(
                      color: _isNearbyMode
                          ? Colors.transparent
                          : theme.colorScheme.outline.withOpacity(0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Category filters
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // "All" option
                        final isSelected = _selectedCategoryId == null;
                        return _buildCategoryChip(
                          label: 'Все',
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedCategoryId = null;
                            });
                          },
                          theme: theme,
                        );
                      }

                      final category = _categories[index - 1];
                      final isSelected = _selectedCategoryId == category.id;
                      return _buildCategoryChip(
                        label: category.title,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.id;
                          });
                        },
                        theme: theme,
                        icon: _getCategoryIcon(category.id),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // Info message when nearby mode is active
        if (_isNearbyMode && _currentPosition != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Места отсортированы по расстоянию от вас',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimaryContainer,
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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

  void _showPlaceDetails(BuildContext context, Place place, Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                place.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(category.title),
                avatar: Icon(_getCategoryIcon(category.id), size: 18),
              ),
              const SizedBox(height: 16),
              Text(
                place.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _openMaps(place);
                },
                icon: const Icon(Icons.map),
                label: const Text('Открыть на карте'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMaps(Place place) {
    final category = _categories.firstWhere(
      (cat) => cat.id == place.categoryId,
      orElse: () => Category(id: '', title: ''),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          places: _filteredPlaces,
          categories: _categories,
          selectedPlace: place,
          currentPosition: _currentPosition,
        ),
      ),
    );
  }

  void _openFullMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          places: _filteredPlaces,
          categories: _categories,
          currentPosition: _currentPosition,
        ),
      ),
    );
  }
}