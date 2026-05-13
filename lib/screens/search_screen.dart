import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zubimovie/common/utils.dart';
import 'package:zubimovie/models/movie_recommendation_model.dart';
import 'package:zubimovie/models/search_model.dart';
import 'package:zubimovie/screens/movie_detailed_screen.dart';
import 'package:zubimovie/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ApiServices apiServices = ApiServices();
  late Future<MovieRecommendationModel> popularMovies;

  SearchModel? searchModel;
  bool isLoading = false;
  bool searchFailed = false;
  Timer? _debounce;
  int _seq = 0;

  static const Duration _searchDebounce = Duration(milliseconds: 450);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    popularMovies = apiServices.getPopularMovies();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _clearSearchUi() {
    _debounce?.cancel();
    _seq++;
    setState(() {
      searchModel = null;
      searchFailed = false;
      isLoading = false;
    });
  }

  void _onSearchChanged(String raw) {
    _debounce?.cancel();
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      _clearSearchUi();
      return;
    }
    _debounce = Timer(_searchDebounce, () {
      if (!mounted) return;
      _runSearch(trimmed);
    });
  }

  Future<void> _runSearch(String query) async {
    final id = ++_seq;
    setState(() {
      isLoading = true;
      searchFailed = false;
    });

    try {
      final results = await apiServices.getSearchedMovie(query);
      if (!mounted || id != _seq) return;
      setState(() {
        searchModel = results;
        isLoading = false;
        searchFailed = false;
      });
    } catch (e) {
      debugPrint('Search error: $e');
      if (!mounted || id != _seq) return;
      setState(() {
        searchModel = null;
        isLoading = false;
        searchFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CupertinoSearchTextField(
                padding: const EdgeInsets.all(10),
                controller: searchController,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.clear, color: Colors.grey),
                onSuffixTap: () {
                  _debounce?.cancel();
                  searchController.clear();
                  _clearSearchUi();
                },
                style: const TextStyle(color: Colors.white),
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 20),

              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (searchController.text.trim().isEmpty)
                Expanded(
                  child: FutureBuilder<MovieRecommendationModel>(
                    future: popularMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Error loading top searches",
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    popularMovies =
                                        apiServices.getPopularMovies();
                                  });
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final results = snapshot.data?.results ?? [];
                        final filtered = results
                            .where((r) => r.posterPath.isNotEmpty)
                            .toList();

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text(
                              "No top searches found",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                "Top Searches",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final movie = filtered[index];
                                  final posterUrl =
                                      '$imageUrl${movie.posterPath}';
                                  final title = movie.title.isNotEmpty
                                      ? movie.title
                                      : 'No Title';

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailedScreen(
                                                movieId: movie.id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: posterUrl,
                                                width: 100,
                                                height: 150,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "No data found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    },
                  ),
                )
              else if (searchFailed)
                const Expanded(
                  child: Center(
                    child: Text(
                      'Search failed. Check your connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                )
              else if (searchModel == null ||
                  (searchModel?.results.isEmpty ?? true))
                const Expanded(
                  child: Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    itemCount: searchModel?.results.length ?? 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      final result = searchModel!.results[index];
                      final imagePath =
                          result.posterPath ?? result.backdropPath;
                      final imageUrlFull = imagePath != null
                          ? "$imageUrl$imagePath"
                          : 'https://via.placeholder.com/150';

                      final title = result.title ?? 'No Title';

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailedScreen(movieId: result.id),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrlFull,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/logo.png",
                                    height: 170,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
