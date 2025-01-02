import 'package:episode_tracker/screens/show_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/genre.dart';
import '../models/tv_show.dart';
import '../services/api_service.dart';

class ShowsByGenreScreen extends StatefulWidget {
  final Genre genre;

  ShowsByGenreScreen({required this.genre});

  @override
  _ShowsByGenreScreenState createState() => _ShowsByGenreScreenState();
}

class _ShowsByGenreScreenState extends State<ShowsByGenreScreen> {
  final ApiService _apiService = ApiService();
  List<TvShow> _shows = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  Future<void> _loadShows() async {
    setState(() => _isLoading = true);
    try {
      final shows = await _apiService.getShowsByGenre(widget.genre.id);
      setState(() => _shows = shows.map((show) => TvShow.fromJson(show)).toList());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Diziler yüklenirken hata oluştu')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genre.name),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _shows.length,
              itemBuilder: (context, index) {
                final show = _shows[index];
                return ListTile(
                  leading: show.posterPath != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${show.posterPath}',
                          width: 50,
                          errorBuilder: (_, __, ___) => Icon(Icons.movie),
                        )
                      : Icon(Icons.movie),
                  title: Text(show.name),
                  subtitle: Text(
                    show.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowDetailScreen(show: show),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
} 