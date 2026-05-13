import 'dart:convert';

class MovieDetailedModel {
  bool adult;
  String backdropPath;
  dynamic belongsToCollection;
  int budget;
  List<Genre> genres;
  String homepage;
  int id;
  String imdbId;
  List<String> originCountry;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  List<ProductionCompany> productionCompanies;
  List<ProductionCountry> productionCountries;
  DateTime releaseDate;
  int revenue;
  int runtime;
  List<SpokenLanguage> spokenLanguages;
  String status;
  String tagline;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  MovieDetailedModel({
    required this.adult,
    required this.backdropPath,
    required this.belongsToCollection,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  MovieDetailedModel copyWith({
    bool? adult,
    String? backdropPath,
    dynamic belongsToCollection,
    int? budget,
    List<Genre>? genres,
    String? homepage,
    int? id,
    String? imdbId,
    List<String>? originCountry,
    String? originalLanguage,
    String? originalTitle,
    String? overview,
    double? popularity,
    String? posterPath,
    List<ProductionCompany>? productionCompanies,
    List<ProductionCountry>? productionCountries,
    DateTime? releaseDate,
    int? revenue,
    int? runtime,
    List<SpokenLanguage>? spokenLanguages,
    String? status,
    String? tagline,
    String? title,
    bool? video,
    double? voteAverage,
    int? voteCount,
  }) => MovieDetailedModel(
    adult: adult ?? this.adult,
    backdropPath: backdropPath ?? this.backdropPath,
    belongsToCollection: belongsToCollection ?? this.belongsToCollection,
    budget: budget ?? this.budget,
    genres: genres ?? this.genres,
    homepage: homepage ?? this.homepage,
    id: id ?? this.id,
    imdbId: imdbId ?? this.imdbId,
    originCountry: originCountry ?? this.originCountry,
    originalLanguage: originalLanguage ?? this.originalLanguage,
    originalTitle: originalTitle ?? this.originalTitle,
    overview: overview ?? this.overview,
    popularity: popularity ?? this.popularity,
    posterPath: posterPath ?? this.posterPath,
    productionCompanies: productionCompanies ?? this.productionCompanies,
    productionCountries: productionCountries ?? this.productionCountries,
    releaseDate: releaseDate ?? this.releaseDate,
    revenue: revenue ?? this.revenue,
    runtime: runtime ?? this.runtime,
    spokenLanguages: spokenLanguages ?? this.spokenLanguages,
    status: status ?? this.status,
    tagline: tagline ?? this.tagline,
    title: title ?? this.title,
    video: video ?? this.video,
    voteAverage: voteAverage ?? this.voteAverage,
    voteCount: voteCount ?? this.voteCount,
  );

  factory MovieDetailedModel.fromRawJson(String str) =>
      MovieDetailedModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MovieDetailedModel.fromJson(
    Map<String, dynamic> json,
  ) => MovieDetailedModel(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"] ?? '',
    belongsToCollection: json["belongs_to_collection"],
    budget: json["budget"] ?? 0,
    genres: json["genres"] != null
        ? List<Genre>.from(
            (json["genres"] as List).map((x) => Genre.fromJson(x)),
          )
        : [],
    homepage: json["homepage"] ?? '',
    id: json["id"] ?? 0,
    imdbId: json["imdb_id"] ?? '',
    originCountry: json["origin_country"] != null
        ? List<String>.from(json["origin_country"].map((x) => x))
        : [],
    originalLanguage: json["original_language"] ?? '',
    originalTitle: json["original_title"] ?? '',
    overview: json["overview"] ?? '',
    popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
    posterPath: json["poster_path"] ?? '',
    productionCompanies: json["production_companies"] != null
        ? List<ProductionCompany>.from(
            (json["production_companies"] as List)
                .map((x) => ProductionCompany.fromJson(x)),
          )
        : [],
    productionCountries: json["production_countries"] != null
        ? List<ProductionCountry>.from(
            (json["production_countries"] as List)
                .map((x) => ProductionCountry.fromJson(x)),
          )
        : [],
    releaseDate:
        DateTime.tryParse(json["release_date"]?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    revenue: json["revenue"] ?? 0,
    runtime: json["runtime"] ?? 0,
    spokenLanguages: json["spoken_languages"] != null
        ? List<SpokenLanguage>.from(
            (json["spoken_languages"] as List)
                .map((x) => SpokenLanguage.fromJson(x)),
          )
        : [],
    status: json["status"] ?? '',
    tagline: json["tagline"] ?? '',
    title: json["title"] ?? '',
    video: json["video"] ?? false,
    voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
    voteCount: json["vote_count"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "belongs_to_collection": belongsToCollection,
    "budget": budget,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "imdb_id": imdbId,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "production_companies": List<dynamic>.from(
      productionCompanies.map((x) => x.toJson()),
    ),
    "production_countries": List<dynamic>.from(
      productionCountries.map((x) => x.toJson()),
    ),
    "release_date":
        "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    "revenue": revenue,
    "runtime": runtime,
    "spoken_languages": List<dynamic>.from(
      spokenLanguages.map((x) => x.toJson()),
    ),
    "status": status,
    "tagline": tagline,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}

class Genre {
  int id;
  String name;

  Genre({required this.id, required this.name});

  Genre copyWith({int? id, String? name}) =>
      Genre(id: id ?? this.id, name: name ?? this.name);

  factory Genre.fromRawJson(String str) => Genre.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class ProductionCompany {
  int id;
  String? logoPath;
  String name;
  String originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  ProductionCompany copyWith({
    int? id,
    String? logoPath,
    String? name,
    String? originCountry,
  }) => ProductionCompany(
    id: id ?? this.id,
    logoPath: logoPath ?? this.logoPath,
    name: name ?? this.name,
    originCountry: originCountry ?? this.originCountry,
  );

  factory ProductionCompany.fromRawJson(String str) =>
      ProductionCompany.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        id: json["id"],
        logoPath: json["logo_path"],
        name: json["name"],
        originCountry: json["origin_country"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo_path": logoPath,
    "name": name,
    "origin_country": originCountry,
  };
}

class ProductionCountry {
  String iso31661;
  String name;

  ProductionCountry({required this.iso31661, required this.name});

  ProductionCountry copyWith({String? iso31661, String? name}) =>
      ProductionCountry(
        iso31661: iso31661 ?? this.iso31661,
        name: name ?? this.name,
      );

  factory ProductionCountry.fromRawJson(String str) =>
      ProductionCountry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(iso31661: json["iso_3166_1"], name: json["name"]);

  Map<String, dynamic> toJson() => {"iso_3166_1": iso31661, "name": name};
}

class SpokenLanguage {
  String englishName;
  String iso6391;
  String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  SpokenLanguage copyWith({
    String? englishName,
    String? iso6391,
    String? name,
  }) => SpokenLanguage(
    englishName: englishName ?? this.englishName,
    iso6391: iso6391 ?? this.iso6391,
    name: name ?? this.name,
  );

  factory SpokenLanguage.fromRawJson(String str) =>
      SpokenLanguage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
    englishName: json["english_name"],
    iso6391: json["iso_639_1"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "english_name": englishName,
    "iso_639_1": iso6391,
    "name": name,
  };
}
