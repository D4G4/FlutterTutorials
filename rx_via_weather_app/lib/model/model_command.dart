///`Rx Observables`
///  --extends [Stream]
///
///  --can be passed in place of [Stream] (so if a function accepts a stream, it will always almost accept observable)
///
///  --created by 1) wrapping Dart `Streams` or 2) with a `Factory`
///
///  --`Synchronous` by default, however it does not mean that they can not be Asynchronous
///
///  --You don't have to worry about Single subscription or Broadcast type stream,
///    because they will abstract always feed data in the same order.
///
/// `RxCommand`
///   A method of creating a abstraction that will wrap around handlers.
///
/// Advantage: You allow your data to react to the execution "state" of each command.
///
/// 1) Inherited via [InheritedWidget]
///
/// Types of Observables
///       Default
///       Exception
///       Boolean
///       Two boolean getters that are attached to one another, 1. "hasData()" 2. "hasError()"
///
/// We use MVVM pattern

import 'package:rx_command/rx_command.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rx_via_weather_app/model/weather_model.dart';
import 'package:rx_via_weather_app/model/weather_repo.dart';

class ModelCommand {
  final WeatherRepo weatherRepo;

  final RxCommand<void, bool> getGpsStatus$;
  final RxCommand<void, Position> getCurrentLocation$;
  final RxCommand<bool, bool> radioChecked$;
  final RxCommand<Position, List<WeatherModel>> updateWeather$;
  final RxCommand<int, void> addCities$;

  ModelCommand._(this.weatherRepo, this.getGpsStatus$, this.getCurrentLocation$,
      this.radioChecked$, this.updateWeather$, this.addCities$);

  //One of the main ways of making observables is by using factory constructor
  factory ModelCommand(WeatherRepo repo) {
    final _getGps$ = RxCommand.createAsync2<bool>(repo.getGps);

    final _radioChecked$ = RxCommand.createSync3<bool, bool>((b) {
      print("Radio checked $b");
      return b;
    });

    final _getCurrentLocation$ = RxCommand.createAsync2<Position>(
      repo.getCurrentPosition,
      canExecute: _getGps$,
    );

    final _updateWeather$ =
        RxCommand.createAsync3<Position, List<WeatherModel>>(repo.updateWeather,
            canExecute: _radioChecked$);
    // final _updateWeather$ =
    //     RxCommand.createAsync3<Position, List<WeatherModel>>(repo.updateWeather,
    //         canExecute: _radioChecked$);

    //Relate _getCurrentLocation$ with _updateWeather$
    //_getCurrentLocation$.listen((position) => _updateWeather$);

    _getCurrentLocation$.listen((position) {
      print("_getCurrentLocation.listen ${position.latitude}");
      return _updateWeather$(position);
    });

    final _addCities$ = RxCommand.createSync1<int>(repo.addCities);

    // _addCities$.listen((voidData) {
    //   print("Add cities");
    //   return _getCurrentLocation$;
    // });

    _updateWeather$(null); //Default Toronto will be cooridnated

    return ModelCommand._(repo, _getGps$, _getCurrentLocation$, _radioChecked$,
        _updateWeather$, _addCities$);
  }
}
