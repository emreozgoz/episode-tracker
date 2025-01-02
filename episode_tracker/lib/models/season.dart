class Season {
  final int id;
  final String name;
  final int seasonNumber;
  final int episodeCount;
  final String? posterPath;

  Season({
    required this.id,
    required this.name,
    required this.seasonNumber,
    required this.episodeCount,
    this.posterPath,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      name: json['name'],
      seasonNumber: json['season_number'],
      episodeCount: json['episode_count'],
      posterPath: json['poster_path'],
    );
  }
} 