import 'package:rx_via_weather_app/json/response.dart';

class WeatherModel {
  final String city;
  final double temperature;
  final String description;
  final double rain;
  final double lat;
  final double lng;

  WeatherModel(
      {this.city,
      this.temperature,
      this.description,
      this.rain,
      this.lat,
      this.lng});

  WeatherModel.fromResponse(City response)
      : city = response.name,
        temperature = response.main.temp,
        description = response.weather[0].description,
        rain = response.rain.threeHour,
        lat = response.coord.lat,
        lng = response.coord.lon;
}
