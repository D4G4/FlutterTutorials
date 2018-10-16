import 'package:t42_dependency_injection/model.dart';
import 'package:t42_dependency_injection/photo_repo.dart';

import 'package:flutter/foundation.dart'; //Isolates

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'dart:async';

class ProdRepo extends PhotoRepo {
  static const URL = "https://jsonplaceholder.typicode.com/photos";

  @override
  Future<List<Photo>> fetchPhotos(http.Client client) async {
    final response = await client.get(URL);
    return compute(parseJson, response.body);
  }
}

// Json parsing is an expensive function because it uses mirrors
List<Photo> parseJson(String responseBody) {
  final List<Map> parsed = json.decode(responseBody);
  return parsed.map((json) => Photo.fromJson(json)).toList();
}
