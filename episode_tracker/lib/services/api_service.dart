import 'dart:convert';
import 'package:episode_tracker/models/episode.dart';
import 'package:episode_tracker/models/season.dart';

import '../models/genre.dart';
import '../models/tv_show.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final dio = Dio();
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  Future<List<TvShow>> searchShows(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        '$baseUrl/search/tv',
        queryParameters: {
          'api_key': apiKey,
          'query': query,
          'page': page,
        },
      );
      
      final results = response.data['results'] as List;
      return results.map((show) => TvShow.fromJson(show)).toList();
    } catch (e) {
      throw Exception('Diziler aranırken hata oluştu: $e');
    }
  }

  Future<List<TvShow>> getPopularShows({int page = 1}) async {
    try {
      final response = await dio.get(
        '$baseUrl/tv/popular',
        queryParameters: {
          'api_key': apiKey,
          'page': page,
        },
      );
      
      final results = response.data['results'] as List;
      return results.map((show) => TvShow.fromJson(show)).toList();
    } catch (e) {
      throw Exception('Popüler diziler yüklenirken hata oluştu: $e');
    }
  }

  Future<List<Genre>> getGenres() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/genre/tv/list?api_key=$apiKey&language=tr-TR'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Genre>.from(
          data['genres'].map((x) => Genre.fromJson(x)),
        );
      } else {
        throw Exception('Kategoriler yüklenirken hata oluştu');
      }
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getShowsByGenre(int genreId) async {
    try {
      final response = await dio.get(
        '$baseUrl/discover/tv',
        queryParameters: {
          'api_key': apiKey,
          'language': 'tr-TR',
          'with_genres': genreId,
          'sort_by': 'popularity.desc',
          'vote_count.gte': 100,
        },
      );

      final data = response.data;
      return List<Map<String, dynamic>>.from(data['results']);
    } catch (e) {
      throw Exception('Bir hata oluştu: $e');
    }
  }

  Future<List<Season>> getShowSeasons(int showId) async {
    try {
      final response = await dio.get(
        '$baseUrl/tv/$showId',
        queryParameters: {
          'api_key': apiKey,
          'language': 'tr-TR',
        },
      );
      
      final seasons = response.data['seasons'] as List;
      return seasons.map((season) => Season.fromJson(season)).toList();
    } catch (e) {
      throw Exception('Sezonlar yüklenirken hata oluştu: $e');
    }
  }

  Future<List<Episode>> getSeasonEpisodes(int showId, int seasonNumber) async {
    try {
      final response = await dio.get(
        '$baseUrl/tv/$showId/season/$seasonNumber',
        queryParameters: {
          'api_key': apiKey,
          'language': 'tr-TR',
        },
      );
      
      final episodes = response.data['episodes'] as List;
      return episodes.map((episode) => Episode.fromJson(episode)).toList();
    } catch (e) {
      throw Exception('Bölümler yüklenirken hata oluştu: $e');
    }
  }
} 