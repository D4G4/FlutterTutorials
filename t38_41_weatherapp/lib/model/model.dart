import 'package:t38_41_weatherapp/json/response.dart';

class WeatherModel {
  final String city;
  final double temperature;
  final String description;
  final String iconUrl;
  final double rain;
  final double lat;
  final double lng;

  WeatherModel({
    this.city,
    this.temperature,
    this.description,
    this.iconUrl,
    this.rain,
    this.lat,
    this.lng,
  });

  WeatherModel.fromResponse(City response)
      : city = response.name,
        temperature =
            response.main.temp - 273.15, //Converting kelvin into celsius
        description = response.weather[0]?.description,
        iconUrl = response.weather[0]?.icon,
        rain = response.rain?.threeHour,
        lat = response.coord.lat,
        lng = response.coord.lon;
}
