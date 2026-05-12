
class SearchModel {
  final int page;
  final List<Result> results;
  final int totalPages;
  final int totalResults;

  SearchModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    page: json["page"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );
}

class Result {
  bool adult;
  String? backdropPath;
  List<int> genreIds;
  int id;
  List<String> originCountry;
  String originalLanguage;
  String? originalName; // nullable, kyunki movie me ho bhi sakta hai, na bhi
  String? title; // movie ke liye
  String overview;
  double popularity;
  String? posterPath;
  String? firstAirDate;
  String? name; // TV shows me hota hai, nullable
  double voteAverage;
  int voteCount;

  Result({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    this.originalName,
    this.title,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.firstAirDate,
    this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    id: json["id"],
    originCountry: json["origin_country"] != null
        ? List<String>.from(json["origin_country"].map((x) => x))
        : [],
    originalLanguage: json["original_language"] ?? "",
    originalName: json["original_name"],
    title: json["title"],
    overview: json["overview"] ?? "",
    popularity: (json["popularity"] != null)
        ? json["popularity"].toDouble()
        : 0.0,
    posterPath: json["poster_path"],
    firstAirDate: json["first_air_date"],
    name: json["name"],
    voteAverage: (json["vote_average"] != null)
        ? json["vote_average"].toDouble()
        : 0.0,
    voteCount: json["vote_count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    "original_language": originalLanguage,
    "original_name": originalName,
    "title": title,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "first_air_date": firstAirDate,
    "name": name,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
