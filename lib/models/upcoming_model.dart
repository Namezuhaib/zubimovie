
class UpcomingMovieModel {
  Dates dates;
  int page;
  List<MovieResult> results;
  int totalPages;
  int totalResults;

  UpcomingMovieModel({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory UpcomingMovieModel.fromJson(Map<String, dynamic> json) => UpcomingMovieModel(
        dates: Dates.fromJson(json["dates"]),
        page: json["page"],
        results: List<MovieResult>.from(json["results"].map((x) => MovieResult.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Dates {
  DateTime maximum;
  DateTime minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
      );
}

class MovieResult {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  DateTime? releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  MovieResult({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieResult.fromJson(Map<String, dynamic> json) => MovieResult(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: (json["popularity"] ?? 0).toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"] != null && json["release_date"] != ""
            ? DateTime.tryParse(json["release_date"])
            : null,
        title: json["title"],
        video: json["video"],
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
        voteCount: json["vote_count"],
      );
}
