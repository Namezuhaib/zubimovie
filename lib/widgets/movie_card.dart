import 'package:flutter/material.dart';
import 'package:zubimovie/common/utils.dart';
import 'package:zubimovie/models/upcoming_model.dart';
import 'package:zubimovie/screens/movie_detailed_screen.dart';

class MovieCard extends StatelessWidget {
  final Future<UpcomingMovieModel> future;
  final String headLineText;

  const MovieCard({
    super.key,
    required this.future,
    required this.headLineText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UpcomingMovieModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 220,
            child: Center(
              child: Text(
                "Error loading movies",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final results = snapshot.data?.results ?? [];
          final itemsWithPoster = results
              .where((r) => r.posterPath != null && r.posterPath!.isNotEmpty)
              .toList();

          if (itemsWithPoster.isEmpty) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: Text(
                  "No movies found",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return SizedBox(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    headLineText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: itemsWithPoster.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemBuilder: (context, index) {
                      final posterPath = itemsWithPoster[index].posterPath!;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailedScreen(
                                movieId: itemsWithPoster[index].id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '$imageUrl$posterPath',
                              height: 180,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(
                                  height: 180,
                                  width: 120,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 220,
            child: Center(
              child: Text(
                "No movies found",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
    );
  }
}
