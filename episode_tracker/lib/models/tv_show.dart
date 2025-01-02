import 'package:flutter/material.dart';
import 'genre.dart';

class TvShow {
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final List<Genre> genres;

  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    this.genres = const [],
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      genres: (json['genre_ids'] as List<dynamic>?)
          ?.map((id) => Genre(id: id, name: '', icon: Icons.tv))
          .toList() ?? [],
    );
  }

  String get fullPosterPath {
    return posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750';
  }
} 