import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zubimovie/models/movie_detailed_model.dart';
import 'package:zubimovie/models/movie_recommendation_model.dart';
import 'package:zubimovie/services/api_services.dart';

class MovieDetailedScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailedScreen({super.key, required this.movieId});

  @override
  State<MovieDetailedScreen> createState() => _MovieDetailedScreenState();
}

class _MovieDetailedScreenState extends State<MovieDetailedScreen> {
  final ApiServices apiServices = ApiServices();
  late Future<MovieDetailedModel> movieDetail;
  late Future<MovieRecommendationModel> movieRecommendations;

  // Define the image base URL
  static const String imageUrl = "https://image.tmdb.org/t/p/w500";

  @override
  void initState() {
    super.initState();
    movieDetail = apiServices.getMovieDetail(widget.movieId);
    movieRecommendations = apiServices.getMovieRecommendations(widget.movieId);
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String formatRuntime(int? minutes) {
    if (minutes == null || minutes <= 0) return 'N/A';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MovieDetailedModel>(
        future: movieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load movie details",
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final movie = snapshot.data!;
          final backdropUrl = movie.backdropPath.isNotEmpty
              ? "$imageUrl${movie.backdropPath}"
              : null;
          final posterUrl = movie.posterPath.isNotEmpty
              ? "$imageUrl${movie.posterPath}"
              : null;

          final formattedDate = formatDate(movie.releaseDate);
          final formattedRuntime = formatRuntime(movie.runtime);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Backdrop Image
                Stack(
                  children: [
                    if (backdropUrl != null)
                      CachedNetworkImage(
                        imageUrl: backdropUrl,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        color: Colors.grey[900],
                      ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),

                // Poster + Title + Info + Genres
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: posterUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: posterUrl,
                                    height: 160,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 160,
                                    width: 110,
                                    color: Colors.grey[900],
                                    child: const Icon(
                                      Icons.movie,
                                      color: Colors.white54,
                                      size: 48,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 16),

                          // Movie Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title.isNotEmpty
                                      ? movie.title
                                      : "No Title",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${movie.voteAverage.toStringAsFixed(1)} / 10",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Release: $formattedDate",
                                  style: const TextStyle(color: Colors.white54),
                                ),
                                Text(
                                  "Duration: $formattedRuntime",
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Genres Chips (Horizontal Scroll)
                      if (movie.genres.isNotEmpty)
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: movie.genres.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final genre = movie.genres[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.brown[900],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    genre.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                // Overview Section
                if (movie.overview.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      movie.overview,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),

                // Movie Recommendations Section
                const SizedBox(height: 30),
                FutureBuilder<MovieRecommendationModel>(
                  future: movieRecommendations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Failed to load recommendations",
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.results.isEmpty) {
                      return const SizedBox();
                    } else {
                      final movieRecommendations = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "More like this",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movieRecommendations.results.length,
                              itemBuilder: (context, index) {
                                final recommendation =
                                    movieRecommendations.results[index];
                                final recUrl = recommendation.posterPath
                                        .isNotEmpty
                                    ? "$imageUrl${recommendation.posterPath}"
                                    : null;
                                return Container(
                                  width: 130,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailedScreen(
                                                movieId: movieRecommendations.results[index].id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: recUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: recUrl,
                                            fit: BoxFit.cover,
                                            height: 180,
                                          )
                                        : Container(
                                            height: 180,
                                            color: Colors.grey[900],
                                            child: const Icon(
                                              Icons.movie,
                                              color: Colors.white54,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
