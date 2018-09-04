import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'dart:io';

import 'package:t21_movie_searcher_rxdart_sqflite/model/model.dart';

class MovieDatabase {
  final String tableName = "Movies";

  static final MovieDatabase _instance = MovieDatabase._internal();

// Allows us to access Factory pattern
// Allows us to create multiple instances of our MovieDatabase
  factory MovieDatabase.factory() => _instance;

  static Database _db;

// Provide Db instance and if databse is not yet created, then create one and return that instance
  Future<Database> get dbGetter async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

// Private constructor
  MovieDatabase._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");

    var theDB = await openDatabase(path, version: 1, onCreate: _onCreateDB);
    return theDB;
  }

  void _onCreateDB(Database db, int version) async {
    try {
      await db.execute("""CREATE TABLE $tableName
          (${Movie.KEY_ID} STRING PRIMARY KEY
          ,${Movie.KEY_TITLE} TEXT
          ,${Movie.KEY_POSTER_PATH} TEXT
          ,${Movie.KEY_OVERVIEW} TEXT
          ,${Movie.KEY_FAVORED} BIT)""");
      print("Database created!!");
    } catch (e) {
      print("database not created");
      print(e);
    }
  }

  Future<List<Movie>> getMovies() async {
    var dbClient = await dbGetter;
    List<Map> res = await dbClient.query(tableName);
    return res.map((m) => Movie.fromDB(m)).toList();
  }

  Future<Movie> getMovie(String id) async {
    var dbClient = await dbGetter;
    var res = await dbClient
        .query(tableName, where: "${Movie.KEY_ID} = ?", whereArgs: [id]);
    if (res.length == 0) return null;
    return Movie.fromDB(res[0]);
  }

  Future<int> addMovie(Movie movie) async {
    var dbClient = await dbGetter;
    try {
      int res = await dbClient.insert(tableName, movie.toMap());
      print("Movie added $res");
      return res;
    } catch (e) {
      int res = await updateMovie(movie);
      return res;
    }
  }

  Future<int> deleteMovie(String id) async {
    var dbClient = await dbGetter;
    var res = await dbClient
        .delete(tableName, where: "${Movie.KEY_ID} = ?", whereArgs: [id]);
    print("Movie deleted $res");
    return res;
  }

  Future<int> updateMovie(Movie movie) async {
    var dbClient = await dbGetter;
    var res = await dbClient.update(tableName, movie.toMap(),
        where: "${Movie.KEY_ID} = ?", whereArgs: [movie.id]);
    print('Movie updated $res');
    return res;
  }

  Future closeDb() async {
    var dbClient = await dbGetter;
    dbClient.close();
  }
}
