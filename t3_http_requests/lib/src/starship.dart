import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:built_value/serializer.dart';

import 'package:t3_http_requests/src/serializer.dart';

import 'dart:convert';

part 'starship.g.dart';

abstract class Starship implements Built<Starship, StarshipBuilder> {

  static Serializer<Starship> get serializer => _$starshipSerializer; 

  int get count;

  @nullable
  String get next;

  BuiltList<Result> get results;

  Starship._();
  factory Starship([updates(StarshipBuilder b)]) = _$Starship;
}

abstract class Result implements Built<Result, ResultBuilder>{
  static Serializer<Result> get serializer => _$resultSerializer;

  @nullable
  String get name;

  @nullable
  String get model;

  @nullable
  String get manufacturer;

  @JsonKey(name: "starship_class")
  @nullable
  String get starshipClass;

  Result._();
  factory Result([updates(ResultBuilder b)]) = _$Result;

} 

Starship parseStarship(String responseString) {
  final response = json.decode(responseString);
  Starship starship =  serializers.deserializeWith(Starship.serializer, response);
  return starship;
}