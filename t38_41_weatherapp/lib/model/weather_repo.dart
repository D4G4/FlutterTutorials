import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';

import 'package:t38_41_weatherapp/json/response.dart'; //used for parsing
import 'package:t38_41_weatherapp/model/model.dart'; //converting into our Required model (WeatherModel)

import 'package:t38_41_weatherapp/const.dart';

class WeatherRepo {
  final http.Client client;

  WeatherRepo({this.client});

  int cnt = 50; //Max

  void addCities(int count) {
    cnt = count;
  }

  Future<List<WeatherModel>> updateWeather(Position result) async {
    print("Inside updateWeather");
    String url = "";
    if (result != null) {
      print("result != null");
      //'cnt' field allows us to fetch more cities
      url =
          "http://api.openweathermap.org/data/2.5/find?lat=${result.latitude}&lon=${result.longitude}&cnt=$cnt&appid=$API_KEY";
      // "http://api.openweathermap.org/data/2.5/find?lat=43&lon=-79&appid=${API_KEY}"; //Toronto
    } else {
      print("result == null");
      url =
          "http://api.openweathermap.org/data/2.5/find?lat=43&lon=-79&appid=${API_KEY}"; //Toronto
    }

    final response = await client.get(url);
    print("Response  = \n ${response.body}");
    List<WeatherModel> req = BaseResponse.fromJson(json.decode(response.body))
        .cities
        .map((city) => WeatherModel.fromResponse(city))
        .toList();
    return req;
  }

  Future<Position> getCurrentPosition() async {
    print("getCurrentPosition()");
    var locator = Geolocator();
    Position position = await locator.getCurrentPosition(LocationAccuracy.best);
    print("Locatio ${position.latitude}");
    return position;
  }

  Future<bool> getGps() async {
    print("getGps()");
    final GeolocationStatus permissionStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    return permissionStatus == GeolocationStatus.granted;
  }
}
