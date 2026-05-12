import 'dart:convert';
import 'dart:developer';

import 'package:zubimovie/common/utils.dart';
import 'package:zubimovie/models/movie_detailed_model.dart';
import 'package:zubimovie/models/movie_recommendation_model.dart';
import 'package:zubimovie/models/search_model.dart';
import 'package:zubimovie/models/tv_series_model.dart';
import 'package:zubimovie/models/upcoming_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    final String endPoint = 'movie/upcoming';
    final String url = '$baseUrl$endPoint?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));
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

    final response = await http.get(Uri.parse(url));
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

    final response = await http.get(Uri.parse(url));
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

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('getPopularMovies: success');
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }

    log('getPopularMovies: failed (${response.statusCode}) - ${response.body}');
    throw Exception('Failed to load popular movies: ${response.statusCode}');
  }

  Future<SearchModel> getSearchedMovie(String searchText) async {
    final String query = Uri.encodeComponent(searchText);
    final String url = '${baseUrl}search/movie?query=$query';

    print('Search URL is $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyN2FiZjU3NWI2OGYzNzFiZjc4YjgwNzNjNmUxZDFmMSIsIm5iZiI6MTc1NzMzMzA2OS4wNDYwMDAyLCJzdWIiOiI2OGJlYzY0ZGYyM2QzZTMyMDM5NDdjYjAiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.SCSPZVTu7MwKYB9tQW2-aENypMaJ_pi0vii3ymNWRqc',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      log('getSearchedMovie: success');
      return SearchModel.fromJson(jsonDecode(response.body));
    }

    log('getSearchedMovie: failed (${response.statusCode}) - ${response.body}');
    throw Exception('Failed to load searched movies: ${response.statusCode}');
  }

  Future<MovieDetailedModel> getMovieDetail(int movieId) async {
    final url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return MovieDetailedModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load details');
    }
  }

  Future<MovieRecommendationModel> getMovieRecommendations(int movieId) async {
    final String endPoint = 'movie/$movieId/recommendations';
    final String url = '$baseUrl$endPoint?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('getMovieRecommendations: success');
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load more like this");
  }
}
