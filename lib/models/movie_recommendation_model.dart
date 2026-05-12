
class MovieRecommendationModel {
  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  MovieRecommendationModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieRecommendationModel.fromJson(Map<String, dynamic> json) {
    return MovieRecommendationModel(
      page: json["page"] ?? 1,
      results: (json["results"] as List)
          .map((item) => Result.fromJson(item))
          .toList(),
      totalPages: json["total_pages"] ?? 1,
      totalResults: json["total_results"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": results.map((x) => x.toJson()).toList(),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class Result {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  OriginalLanguage originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"] ?? '',
    genreIds: json["genre_ids"] != null
        ? List<int>.from(json["genre_ids"].map((x) => x))
        : [],
    id: json["id"] ?? 0,
    originalLanguage:
        originalLanguageValues.map[json["original_language"]] ??
        OriginalLanguage.EN,
    originalTitle: json["original_title"] ?? '',
    overview: json["overview"] ?? '',
    popularity: (json["popularity"] ?? 0).toDouble(),
    posterPath: json["poster_path"] ?? '',
    releaseDate:
        (json["release_date"] != null &&
            json["release_date"].toString().isNotEmpty)
        ? DateTime.tryParse(json["release_date"]) ?? DateTime(1900)
        : DateTime(1900),
    title: json["title"] ?? '',
    video: json["video"] ?? false,
    voteAverage: (json["vote_average"] ?? 0).toDouble(),
    voteCount: json["vote_count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": genreIds,
    "id": id,
    "original_language": originalLanguageValues.reverse[originalLanguage],
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "release_date":
        "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}

enum OriginalLanguage { EN, FR, JA, ZH }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "fr": OriginalLanguage.FR,
  "ja": OriginalLanguage.JA,
  "zh": OriginalLanguage.ZH,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
