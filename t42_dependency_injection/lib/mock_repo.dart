import 'package:t42_dependency_injection/model.dart';
import 'package:t42_dependency_injection/photo_repo.dart';

import 'package:flutter/foundation.dart'; //Isolates

import 'package:http/http.dart' as http;

import 'dart:async';

class MockRepo extends PhotoRepo {
  @override
  Future<List<Photo>> fetchPhotos(http.Client client) async {
    return compute(createPhotos, 400);
  }
}

///Why didn't we put this function inside the above class?
///Because the `compute` function will not be able to run it
List<Photo> createPhotos(int x) {
  return List.generate(x, (int i) {
    return Photo(
      id: i,
      title: 'example $i',
      url: "https://placeimg.com/640/480/tech/$i",
    );
  });
}
