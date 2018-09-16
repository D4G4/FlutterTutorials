import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

///Why are we extending `Object`?
/// So that the Serialization works properly.
/// By extending objects, we make sure that we have the `toString()` and the `hash()`
/// and when we actually add mix-ins which is what the generated code will give us,
/// it will let us work things more smoothly

@JsonSerializable()
class BaseResponse extends Object {
  final String message;
  final String cod;
  final int count;

  @JsonKey(name: 'list')
  final List<City> cities;

  BaseResponse({this.message, this.cod, this.count, this.cities});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
}

@JsonSerializable()
class City extends Object {
  final int id;
  final String name;
  final Coord coord;
  final Main main;
  final int dt;
  @JsonKey(nullable: true)
  final Wind wind;
  @JsonKey(nullable: true)
  final Rain rain;
  final Clouds clouds;
  final List<Weather> weather;

  City({
    this.id,
    this.name,
    this.coord,
    this.main,
    this.dt,
    this.wind,
    this.rain,
    this.clouds,
    this.weather,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@JsonSerializable()
class Coord extends Object {
  final double lat, lon;
  Coord({this.lat, this.lon});
  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@JsonSerializable()
class Main extends Object {
  final double temp;
  final double pressure;
  final int humidity;
  @JsonKey(name: "temp_max")
  final double maxTemp;
  @JsonKey(name: "temp_min")
  final double minTemp;
  Main({this.temp, this.pressure, this.humidity, this.maxTemp, this.minTemp});
  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@JsonSerializable()
class Wind extends Object {
  final double speed;
  final double deg;

  @JsonKey(nullable: true)
  final double gust;

  Wind({this.speed, this.deg, this.gust});
  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}

@JsonSerializable()
class Rain extends Object {
  @JsonKey(name: "3h")
  final double threeHour;
  Rain({this.threeHour});
  factory Rain.fromJson(Map<String, dynamic> json) => _$RainFromJson(json);
}

@JsonSerializable()
class Clouds extends Object {
  final int all;
  Clouds({this.all});
  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@JsonSerializable()
class Weather extends Object {
  final int id;
  final String main;
  final String description;
  final String icon;
  Weather({this.id, this.main, this.description, this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
