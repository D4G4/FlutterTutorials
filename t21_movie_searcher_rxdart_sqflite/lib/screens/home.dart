import 'package:flutter/material.dart';
import 'package:t21_movie_searcher_rxdart_sqflite/model/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:t21_movie_searcher_rxdart_sqflite/screens/movieView.dart';

import 'dart:convert';

const API_KEY = 'fb3a169455f98a5219e433c8790356e5';
const URL = "https://api.themoviedb.org/3/search/movie/";

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  List<Movie> movies = List();
  bool hasLoaded = true;

//  Basically a StreamController but returns an Observable instead of a Stream
//  So we can listen to this subject by multiple listeners and use the result in
//  different way
  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(Duration(milliseconds: 400)).listen(searchMovies);
  }

  void searchMovies(query) {
    resetMovies();
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
    }
    setState(() {
      hasLoaded = false;
    });
    //Use Jaguar here
    String getUrl = URL + '?api_key=' + API_KEY + '&query=' + query;
    http
        .get(getUrl)
        .then((res) => (res.body))
        .then((body) => json.decode(body))
        .then((decodedBody) => decodedBody['results'])
        .then((resultsMap) => resultsMap.forEach(addToMovie))
        .catchError(onError)
        .then((e) {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  void onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void addToMovie(result) {
    setState(() {
      movies.add(Movie.fromJson(result));
    });
    print('${movies.map((m) => m.title)}');
  }

  void resetMovies() {
    setState(() {
      movies.clear();
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (String string) => (subject.add(string)), //Debounce?
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: hasLoaded ? Container() : CircularProgressIndicator(),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  return new MovieView(movies[index]);
                },
              ),
            )
          ],
        ),
      );
}
