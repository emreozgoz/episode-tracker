import 'package:episode_tracker/models/episode.dart';
import 'package:flutter/material.dart';
import '../models/season.dart';
import '../services/api_service.dart';

class SeasonDetailScreen extends StatefulWidget {
  final int showId;
  final Season season;

  SeasonDetailScreen({required this.showId, required this.season});

  @override
  _SeasonDetailScreenState createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  final ApiService _apiService = ApiService();
  List<Episode> _episodes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEpisodes();
  }

  Future<void> _loadEpisodes() async {
    setState(() => _isLoading = true);
    try {
      final episodes = await _apiService.getSeasonEpisodes(
        widget.showId,
        widget.season.seasonNumber,
      );
      setState(() => _episodes = episodes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bölümler yüklenirken hata oluştu')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.season.name}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _episodes.length,
              itemBuilder: (context, index) {
                final episode = _episodes[index];
                return ListTile(
                  leading: episode.stillPath != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${episode.stillPath}',
                          width: 50,
                          errorBuilder: (_, __, ___) => Icon(Icons.movie),
                        )
                      : Icon(Icons.movie),
                  title: Text('Bölüm ${episode.episodeNumber}: ${episode.name}'),
                  trailing: Checkbox(
                    value: episode.isWatched,
                    onChanged: (bool? value) {
                      setState(() {
                        episode.isWatched = value ?? false;
                      });
                      // TODO: İzlendi durumunu kalıcı depolamada saklamak için
                      // SharedPreferences veya yerel veritabanı kullanılabilir
                    },
                  ),
                );
              },
            ),
    );
  }
} 