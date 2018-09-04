import 'package:flutter/material.dart';

import 'package:t21_movie_searcher_rxdart_sqflite/database/database.dart';
import 'package:t21_movie_searcher_rxdart_sqflite/model/model.dart';

const IMAGE_PATH = "https://image.tmdb.org/t/p/w92";

class MovieView extends StatefulWidget {
  MovieView(this.movie);

  final Movie movie;

  @override
  MovieViewState createState() => MovieViewState();
}

class MovieViewState extends State<MovieView> {
  Movie movieState;

  void initState() {
    super.initState();
    movieState = widget.movie;
    MovieDatabase db = MovieDatabase.factory();
    db.getMovie(movieState.id).then((movie) {
      setState(() {
        movieState.favored = movie.favored;
      });
    });
  }

  void onFavoritesPressed() {
    MovieDatabase db = MovieDatabase.factory();
    setState(() {
      movieState.favored = !movieState.favored;
      movieState.favored == true
          ? db.addMovie(movieState)
          : db.deleteMovie(movieState.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: IconButton(
          icon: movieState.favored ? Icon(Icons.star) : Icon(Icons.star_border),
          color: Colors.white,
          onPressed: onFavoritesPressed),
      title: Container(
        height: 200.0,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            movieState.posterPath != null
                ? Hero(
                    tag: movieState.id,
                    child: Image.network("$IMAGE_PATH${movieState.posterPath}"),
                  )
                : Icon(Icons.broken_image),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(movieState.title, maxLines: 10)),
              ),
            )
          ],
        ),
      ),
      children: <Widget>[
        Container(
          child: RichText(
            text: TextSpan(
                text: movieState.overview,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300)),
          ),
        )
      ],
      initiallyExpanded: movieState.isExpanded ?? false,
      onExpansionChanged: (b) => movieState.isExpanded = b,
    );
  }
}
