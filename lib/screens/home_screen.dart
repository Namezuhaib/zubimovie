import 'package:flutter/material.dart';
import 'package:zubimovie/common/utils.dart';
import 'package:zubimovie/models/tv_series_model.dart';
import 'package:zubimovie/models/upcoming_model.dart';
import 'package:zubimovie/screens/search_screen.dart';
import 'package:zubimovie/services/api_services.dart';
import 'package:zubimovie/widgets/custom_carousel.dart';
import 'package:zubimovie/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  final ApiServices apiServices = ApiServices();

  late Future<Map<String, dynamic>> _allDataFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _allDataFuture = fetchAllData();
  }

  /// All TMDB requests start together; [Future.wait] completes when the slowest finishes.
  Future<Map<String, dynamic>> fetchAllData() async {
    try {
      return await _fetchAllDataOnce();
    } catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 800));
      return await _fetchAllDataOnce();
    }
  }

  Future<Map<String, dynamic>> _fetchAllDataOnce() async {
    try {
      final upcoming = apiServices.getUpcomingMovies();
      final nowPlaying = apiServices.getNowPlayingMovies();
      final topRatedSeries = apiServices.getTopRatedSeries();
      final results = await Future.wait([
        upcoming,
        nowPlaying,
        topRatedSeries,
      ]);

      return {
        "upcoming": results[0] as UpcomingMovieModel,
        "nowPlaying": results[1] as UpcomingMovieModel,
        "topSeries": results[2] as TvSeriesModel,
      };
    } catch (e) {
      throw Exception("Failed to load data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Image.asset('assets/name.png', height: 40, width: 180),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
              child: const Icon(Icons.search, color: Colors.white, size: 30),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/sample.jpg',
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _allDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Error loading data",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _allDataFuture = fetchAllData();
                        });
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          final upcoming = snapshot.data!['upcoming'] as UpcomingMovieModel;
          final nowPlaying = snapshot.data!['nowPlaying'] as UpcomingMovieModel;
          final topSeries = snapshot.data!['topSeries'] as TvSeriesModel;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Top Rated Series Carousel
                topSeries.results.isNotEmpty
                    ? CustomCarouselSlider(data: topSeries)
                    : const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'No Series Found',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),

                MovieCard(
                  data: nowPlaying,
                  headLineText: "Now Playing",
                ),
                const SizedBox(height: 10),

                MovieCard(
                  data: upcoming,
                  headLineText: "Upcoming Movies",
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
