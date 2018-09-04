import 'dart:convert';

import 'package:built_value/built_value.dart'; //for single objects
import 'package:built_collection/built_collection.dart'; //for multiple objects
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'json_parsing.g.dart';

// $ flutter packages pub run build_runner build/watch
abstract class Article implements Built<Article, ArticleBuilder> {
  static Serializer<Article> get serializer => _$articleSerializer;

  
  int get id;

  @nullable
  bool get deleted;

  @nullable
  String get type;

  @nullable
  String get by;

  int get time;

  @nullable
  String get text;

  @nullable
  bool get dead;

  @nullable
  String get parent;

  @nullable
  String get poll;

  BuiltList<int> get kids;

  @nullable
  String get url;

  int get score;

  @nullable
  String get title;

  BuiltList<int> get parts;

  int get descendants;

  Article._();
  factory Article([updates(ArticleBuilder builder)]) = _$Article;
}

List<int> parseTopStories(String jsonString) {
  return [];
  /*final parsedJsonList = json.decode(jsonString);
  final listOfIds = List<int>.from(parsedJsonList);
  return listOfIds;*/
}

Article parseArticle(String jsonString) {
  final parsed = jsonDecode(jsonString);
  Article article = standardSerializers.deserializeWith(Article.serializer, parsed);
  print(article.title);
  return article;
}
