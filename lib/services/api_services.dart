import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:zubimovie/common/utils.dart';
import 'package:zubimovie/models/movie_detailed_model.dart';
import 'package:zubimovie/models/movie_recommendation_model.dart';
import 'package:zubimovie/models/search_model.dart';
import 'package:zubimovie/models/tv_series_model.dart';
import 'package:zubimovie/models/upcoming_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const Duration _httpTimeout = Duration(seconds: 22);
  static const int _maxHttpAttempts = 4;

  /// Retries on timeouts, 429, and 5xx — reduces "works only after many Retries" behaviour.
  Future<http.Response> _httpGet(Uri uri) async {
    http.Response? last;
    for (var attempt = 0; attempt < _maxHttpAttempts; attempt++) {
      try {
        last = await http.get(uri).timeout(_httpTimeout);
      } catch (e, st) {
        log('_httpGet attempt ${attempt + 1} failed: $e', stackTrace: st);
        last = null;
        await Future<void>.delayed(
          Duration(milliseconds: 400 * (attempt + 1)),
        );
        continue;
      }

      if (last.statusCode == 200) {
        return last;
      }

      final retryable = last.statusCode == 429 || last.statusCode >= 500;
      if (!retryable) {
        return last;
      }

      var waitMs = 500 * math.pow(2, attempt).toInt();
      final ra = last.headers['retry-after'];
      if (ra != null) {
        final seconds = int.tryParse(ra.trim());
        if (seconds != null) {
          waitMs = (seconds * 1000).clamp(500, 15000);
        }
      }
      await Future<void>.delayed(Duration(milliseconds: waitMs));
    }

    return last ?? http.Response('', 599);
  }

  Future<UpcomingMovieModel> getUpcomingMovies() async {
    final String endPoint = 'movie/upcoming';
    final String url = '$baseUrl$endPoint?api_key=$apiKey';

    final response = await _httpGet(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getUpcomingMovies: success');
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }

    log(
      'getUpcomingMovies: failed (${response.statusCode}) - ${response.body}',
    );
    throw Exception('Failed to load upcoming movies: ${response.statusCode}');
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    final String endPoint = 'movie/now_playing';
    final String url = '$baseUrl$endPoint?api_key=$apiKey';

    final response = await _httpGet(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getNowPlayingMovies: success');
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }

    log(
      'getNowPlayingMovies: failed (${response.statusCode}) - ${response.body}',
    );
    throw Exception(
      'Failed to load now playing movies: ${response.statusCode}',
    );
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    // NOTE: original code used a movie recommendations endpoint here.
    // For a method named "getTopRatedSeries" we should call the TV top-rated endpoint.
    final String endPoint = 'tv/top_rated';
    final String url = '$baseUrl$endPoint?api_key=$apiKey';

    final response = await _httpGet(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getTopRatedSeries: success');
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }

    log(
      'getTopRatedSeries: failed (${response.statusCode}) - ${response.body}',
    );
    throw Exception('Failed to load top rated series: ${response.statusCode}');
  }

  Future<MovieRecommendationModel> getPopularMovies() async {
    final String endPoint = 'movie/popular';
    final String url = '$baseUrl$endPoint?api_key=$apiKey';

    final response = await _httpGet(Uri.parse(url));

    if (response.statusCode == 200) {
      log('getPopularMovies: success');
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }

    log('getPopularMovies: failed (${response.statusCode}) - ${response.body}');
    throw Exception('Failed to load popular movies: ${response.statusCode}');
  }

  Future<SearchModel> getSearchedMovie(String searchText) async {
    final String query = Uri.encodeComponent(searchText);
    final String url =
        '${baseUrl}search/movie?api_key=$apiKey&query=$query';

    log('getSearchedMovie: query submitted');

    final response = await _httpGet(Uri.parse(url));

    if (response.statusCode == 200) {
      log('getSearchedMovie: success');
      return SearchModel.fromJson(jsonDecode(response.body));
    }

    log('getSearchedMovie: failed (${response.statusCode}) - ${response.body}');
    throw Exception('Failed to load searched movies: ${response.statusCode}');
  }

  Future<MovieDetailedModel> getMovieDetail(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';

    final response = await _httpGet(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieDetailedModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load details');
    }
  }

  Future<MovieRecommendationModel> getMovieRecommendations(int movieId) async {
    final String endPoint = 'movie/$movieId/recommendations';
    final String url = '$baseUrl$endPoint?api_key=$apiKey';

    final response = await _httpGet(Uri.parse(url));

    if (response.statusCode == 200) {
      log('getMovieRecommendations: success');
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load more like this");
  }
}
