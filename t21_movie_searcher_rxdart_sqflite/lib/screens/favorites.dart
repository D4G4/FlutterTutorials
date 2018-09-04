import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:t21_movie_searcher_rxdart_sqflite/model/model.dart';
import 'package:t21_movie_searcher_rxdart_sqflite/database/database.dart';

const IMAGE_PATH = "https://image.tmdb.org/t/p/w92";

class Favorites extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoritesState();
  }
}

class FavoritesState extends State<Favorites> {
  List<Movie> filteredMovies = List();
  List<Movie> movieCache = List();

  final PublishSubject subject = PublishSubject<String>();

  void initState() {
    super.initState();
    filteredMovies = [];
    movieCache = [];
    subject.stream.listen(searchDataList);
    setupList();
  }

  void setupList() async {
    MovieDatabase database = MovieDatabase.factory();
    filteredMovies = await database.getMovies();
    setState(() {
      movieCache = filteredMovies;
    });
  }

  void onDeletePressed(index) {
    MovieDatabase database = MovieDatabase.factory();
    database.deleteMovie(filteredMovies[index].id);
    setState(() {
      filteredMovies.remove(filteredMovies[index]);
      movieCache = filteredMovies;
    });
  }

  void searchDataList(query) {
    if (query.isEmpty) {
      setState(() {
        filteredMovies = movieCache;
      });
    }
    setState(() {});
    filteredMovies = filteredMovies
        .where((m) => m.title
            .toLowerCase()
            .trim()
            .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
        .toList();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    subject.close();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (String string) => subject.add(string),
              keyboardType: TextInputType.url, //all lowercase
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                Movie movie = filteredMovies[index];
                return ExpansionTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      onDeletePressed(index);
                    },
                  ),
                  title: Container(
                    height: 200.0,
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        filteredMovies[index].posterPath != null
                            ? Hero(
                                tag: filteredMovies[index].id,
                                child: Image.network(
                                    "$IMAGE_PATH${filteredMovies[index].posterPath}"),
                              )
                            : Icon(Icons.broken_image),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(filteredMovies[index].title,
                                    maxLines: 10)),
                          ),
                        )
                      ],
                    ),
                  ),
                  initiallyExpanded: movie.isExpanded ?? false,
                  onExpansionChanged: (b) =>
                      movie.isExpanded = b, // Will this work? PassByReference?
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
