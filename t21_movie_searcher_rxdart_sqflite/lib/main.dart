import 'package:flutter/material.dart';

import 'package:t21_movie_searcher_rxdart_sqflite/learning/hero_animation_widget.dart'
    as HeroWidgetExample;
import 'package:t21_movie_searcher_rxdart_sqflite/screens/home.dart';
import 'package:t21_movie_searcher_rxdart_sqflite/screens/favorites.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Searcher",
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("movie searcher app"),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.home), text: 'Home Page'),
                  Tab(icon: Icon(Icons.favorite), text: 'Favorites')
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                HomePage(),
                Favorites(),
              ],
            )),
      ),
      //home: HeroWidgetExample.MainScreen()
    );
  }
}
