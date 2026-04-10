import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tutly/models/category.dart';
import 'package:tutly/models/place.dart';
import 'package:tutly/models/route.dart';

class DataService {
  Future<List<Category>> loadCategories() async {
    final jsonString = await rootBundle.loadString('assets/data/places.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final categoriesJson = json['categories'] as List<dynamic>;
    return categoriesJson
        .map((categoryJson) => Category.fromJson(categoryJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<Place>> loadPlaces() async {
    final jsonString = await rootBundle.loadString('assets/data/places.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final placesJson = json['places'] as List<dynamic>;
    return placesJson
        .map((placeJson) => Place.fromJson(placeJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<Route>> loadRoutes() async {
    final jsonString = await rootBundle.loadString('assets/data/places.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final routesJson = json['routes'] as List<dynamic>;
    return routesJson
        .map((routeJson) => Route.fromJson(routeJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<Place>> getPlacesByCategory(String categoryId) async {
    final allPlaces = await loadPlaces();
    return allPlaces.where((place) => place.categoryId == categoryId).toList();
  }

  Future<List<Place>> getPlacesByIds(List<int> ids) async {
    final allPlaces = await loadPlaces();
    return allPlaces.where((place) => ids.contains(place.id)).toList();
  }
}