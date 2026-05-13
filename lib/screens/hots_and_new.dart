import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zubimovie/common/utils.dart';
import 'package:zubimovie/models/movie_recommendation_model.dart';
import 'package:zubimovie/models/upcoming_model.dart';
import 'package:zubimovie/services/api_services.dart';
import 'package:zubimovie/widgets/coming_soon_movie.dart';

class HotsAndNewScreen extends StatefulWidget {
  const HotsAndNewScreen({super.key});

  @override
  State<HotsAndNewScreen> createState() => _HotsAndNewScreenState();
}

class _HotsAndNewScreenState extends State<HotsAndNewScreen> {
  final ApiServices _api = ApiServices();
  late final Future<UpcomingMovieModel> _upcomingFuture;
  late final Future<MovieRecommendationModel> _popularFuture;

  @override
  void initState() {
    super.initState();
    _upcomingFuture = _api.getUpcomingMovies();
    _popularFuture = _api.getPopularMovies();
  }

  String _monthLabel(DateTime? d) =>
      d != null ? DateFormat('MMM').format(d) : 'TBA';

  String _dayLabel(DateTime? d) =>
      d != null ? DateFormat('d').format(d) : '—';

  Widget _fromUpcoming(MovieResult m) {
    final path = (m.backdropPath != null && m.backdropPath!.isNotEmpty)
        ? m.backdropPath!
        : (m.posterPath ?? '');
    final hero = path.isNotEmpty ? '$imageUrl$path' : '';
    final logo = (m.posterPath != null && m.posterPath!.isNotEmpty)
        ? '$imageUrl${m.posterPath}'
        : null;
    return ComingSoonMovie(
      imageUrl: hero,
      overview: m.overview,
      logoUrl: logo,
      displayTitle: m.title,
      month: _monthLabel(m.releaseDate),
      day: _dayLabel(m.releaseDate),
    );
  }

  Widget _fromPopular(Result m) {
    final path = m.backdropPath.isNotEmpty
        ? m.backdropPath
        : m.posterPath;
    final hero = path.isNotEmpty ? '$imageUrl$path' : '';
    final logo = m.posterPath.isNotEmpty ? '$imageUrl${m.posterPath}' : null;
    final title = m.title.isNotEmpty ? m.title : m.originalTitle;
    return ComingSoonMovie(
      imageUrl: hero,
      overview: m.overview,
      logoUrl: logo,
      displayTitle: title,
      month: _monthLabel(m.releaseDate),
      day: _dayLabel(m.releaseDate),
    );
  }

  Widget _loadingBody() => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );

  Widget _errorBody(String msg, VoidCallback onRetry) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            title: const Text("New & Hots", style: TextStyle(color: Colors.white)),
            actions: [
              const Icon(Icons.cast, color: Colors.white),
              const SizedBox(width: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/sample.jpg',
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
            ],
            bottom: TabBar(
              dividerColor: Colors.black,
              isScrollable: false,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              labelColor: Colors.black,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(text: "  🍿 Coming Soon  "),
                Tab(text: "  🔥 Everyone's Watching  "),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FutureBuilder<UpcomingMovieModel>(
                future: _upcomingFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return _loadingBody();
                  }
                  if (snap.hasError || !snap.hasData) {
                    return _errorBody(
                      'Could not load coming soon.',
                      () => setState(() {
                        _upcomingFuture = _api.getUpcomingMovies();
                      }),
                    );
                  }
                  final list = snap.data!.results;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        'No upcoming titles.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: math.min(list.length, 20),
                    itemBuilder: (_, i) => _fromUpcoming(list[i]),
                  );
                },
              ),
              FutureBuilder<MovieRecommendationModel>(
                future: _popularFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return _loadingBody();
                  }
                  if (snap.hasError || !snap.hasData) {
                    return _errorBody(
                      'Could not load popular picks.',
                      () => setState(() {
                        _popularFuture = _api.getPopularMovies();
                      }),
                    );
                  }
                  final list = snap.data!.results;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nothing here yet.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: math.min(list.length, 20),
                    itemBuilder: (_, i) => _fromPopular(list[i]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
