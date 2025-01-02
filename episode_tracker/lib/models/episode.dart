class Episode {
  final int id;
  final String name;
  final int episodeNumber;
  final String? stillPath;
  bool isWatched;

  Episode({
    required this.id,
    required this.name,
    required this.episodeNumber,
    this.stillPath,
    this.isWatched = false,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      episodeNumber: json['episode_number'],
      stillPath: json['still_path'],
    );
  }
} 