import 'package:t42_dependency_injection/model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

//Will allow us to define the shape of the "Repository"
//This way we can "Inject" the repository into our application based on very small changes
// what we make to the fron-end.
abstract class PhotoRepo {
  Future<List<Photo>> fetchPhotos(http.Client client);
}
