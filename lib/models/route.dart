class Route {
  final int id;
  final String title;
  final String description;
  final List<int> placeIds;
  final int estimatedTimeMinutes;
  final String difficulty;

  Route({
    required this.id,
    required this.title,
    required this.description,
    required this.placeIds,
    required this.estimatedTimeMinutes,
    required this.difficulty,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      placeIds: (json['placeIds'] as List<dynamic>).cast<int>(),
      estimatedTimeMinutes: json['estimatedTimeMinutes'] as int,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'placeIds': placeIds,
      'estimatedTimeMinutes': estimatedTimeMinutes,
      'difficulty': difficulty,
    };
  }
}