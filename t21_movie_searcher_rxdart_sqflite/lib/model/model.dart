import 'package:meta/meta.dart';

class Movie {
  static const String KEY_TITLE = "title";
  static const String KEY_POSTER_PATH = "poster_path";
  static const String KEY_ID = "id";
  static const String KEY_OVERVIEW = "overview";
  static const String KEY_FAVORED = "favored";

  Movie({
    @required this.title,
    @required this.posterPath,
    @required this.id,
    @required this.overview,
    this.favored,
    this.isExpanded,
  });

  String title, posterPath, id, overview;
  bool favored, isExpanded;

  Movie.fromJson(Map json)
      : title = json[KEY_TITLE],
        posterPath = json[KEY_POSTER_PATH],
        id = json[KEY_ID].toString(),
        overview = json[KEY_OVERVIEW],
        favored = false;

  Movie.fromDB(Map map)
      : title = map[KEY_TITLE],
        posterPath = map[KEY_POSTER_PATH],
        id = map[KEY_ID].toString(),
        overview = map[KEY_OVERVIEW],
        favored = map[KEY_FAVORED] == 1;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[KEY_ID] = id;
    map[KEY_TITLE] = title;
    map[KEY_POSTER_PATH] = posterPath;
    map[KEY_OVERVIEW] = overview;
    map[KEY_FAVORED] = favored;
    return map;
  }
}
