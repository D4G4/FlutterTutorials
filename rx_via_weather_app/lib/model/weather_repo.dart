import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';

import 'package:rx_via_weather_app/json/response.dart';

import 'package:rx_via_weather_app/model/weather_model.dart';
import 'package:rx_via_weather_app/const.dart';

class WeatherRepo {
  final http.Client client;

  WeatherRepo({this.client});

  int cnt = 50; //Max

  void addCities(int count) {
    cnt = count;
  }

  Future<List<WeatherModel>> updateWeather(Position position) async {
    String url = "";
    if (position != null) {
      //'cnt' field allows us to fetch more cities
      url =
          "http://api.openweathermap.org/data/2.5/find?lat=${position.latitude}&lon=${position.longitude}&cnt=$cnt&appid=$API_KEY";
    } else {
      print("result == null");
      url =
          "http://api.openweathermap.org/data/2.5/find?lat=43&lon=-79&appid=${API_KEY}"; //Toronto
    }

    final response = await client.get(url);
    print("Response = \n${response.body}");
    List<WeatherModel> res = BaseResponse.fromJson(json.decode(response.body))
        .cities
        .map((city) => WeatherModel.fromResponse(city))
        .toList();
    return res;
  }

  Future<Position> getCurrentPosition() async {
    print("getCurrentPosition()");
    var locator = Geolocator();
    Position position = await locator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print("Location ${position.latitude}");
    return position;
  }

  Future<bool> getGps() async {
    print("getGps()");
    final GeolocationStatus status =
        await Geolocator().checkGeolocationPermissionStatus();
    return status == GeolocationStatus.granted;
  }
}
