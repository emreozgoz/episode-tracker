import 'package:episode_tracker/models/season.dart';
import 'package:episode_tracker/screens/season_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/tv_show.dart';
import '../services/api_service.dart';

class ShowDetailScreen extends StatefulWidget {
  final TvShow show;

  ShowDetailScreen({required this.show});

  @override
  _ShowDetailScreenState createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  final ApiService _apiService = ApiService();
  List<Season> _seasons = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSeasons();
  }

  Future<void> _loadSeasons() async {
    setState(() => _isLoading = true);
    try {
      final seasons = await _apiService.getShowSeasons(widget.show.id);
      setState(() => _seasons = seasons);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sezonlar yüklenirken hata oluştu')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.show.name)),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _seasons.length,
              itemBuilder: (context, index) {
                final season = _seasons[index];
                return ListTile(
                  leading: season.posterPath != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${season.posterPath}',
                          width: 50,
                          errorBuilder: (_, __, ___) => Icon(Icons.tv),
                        )
                      : Icon(Icons.tv),
                  title: Text('Sezon ${season.seasonNumber}'),
                  subtitle: Text('${season.episodeCount} Bölüm'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeasonDetailScreen(
                          showId: widget.show.id,
                          season: season,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
} 