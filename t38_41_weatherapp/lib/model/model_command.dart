import 'package:rx_command/rx_command.dart';
import 'package:geolocator/geolocator.dart';

import 'package:t38_41_weatherapp/model/model.dart';
import 'package:t38_41_weatherapp/model/weather_repo.dart';

class ModelCommand {
  final WeatherRepo weatherRepo;

  final RxCommand<void, Position> commandGetCurrentLocation;
  final RxCommand<Position, List<WeatherModel>> commandUpdateWeather;
  final RxCommand<void, bool> commandGetGps;
  final RxCommand<bool, bool> commandRadioChecked;
  final RxCommand<int, void> commandAddCities;

//Will be used by our Factroy constructor
  ModelCommand._(
      this.weatherRepo,
      this.commandGetCurrentLocation,
      this.commandUpdateWeather,
      this.commandGetGps,
      this.commandRadioChecked,
      this.commandAddCities);

//One of the main ways of making observables is by using factory constructor
  factory ModelCommand(WeatherRepo repo) {
    final _commandGetGps = RxCommand.createAsync2<bool>(
        repo.getGps); //Async2 -> Function that does't have any input parameter

    final _commandRadioCheck = RxCommand.createSync3<bool, bool>((b) {
      print("Just executed _commandRadioCheck $b");
      return b;
    });

    final _commandGetCurrentLocation = RxCommand.createAsync2<Position>(
        repo.getCurrentPosition,
        canExecute: _commandGetGps);

    //Tie _commandRadioCheck with _commandUpdateWeather
    final _commandUpdateWeather =
        RxCommand.createAsync3<Position, List<WeatherModel>>((position) {
      return repo.updateWeather(position);
    }, canExecute: _commandRadioCheck);
    //   RxCommand.createAsync3<Position, List<WeatherModel>>(
    // repo.updateWeather,);

    final _commandAddCities = RxCommand.createSync1<int>(repo.addCities);

    //Relate commandUpdateLocation with commandUpdateWeather
    _commandGetCurrentLocation
        .listen((Position position) => _commandUpdateWeather(position));
    // _commandGetCurrentLocation.results.listen((positionResult) {
    //   print("commandGetCurrentLocation.listen  ${positionResult.data.latitude}");
    //   _commandUpdateWeather(positionResult.data);
    // });

    _commandAddCities.listen((void value) {
      print("commandAddCities.listen");
      return _commandGetCurrentLocation.execute();
    });

    //Initialize data inside app
    _commandUpdateWeather(null);

    return ModelCommand._(
        repo,
        _commandGetCurrentLocation,
        _commandUpdateWeather,
        _commandGetGps,
        _commandRadioCheck,
        _commandAddCities);
  }
}

final List<int> menuNumbers = <int>[5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
