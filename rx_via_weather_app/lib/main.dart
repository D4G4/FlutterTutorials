import 'package:flutter/material.dart';

import 'package:rx_via_weather_app/model/model_provider.dart';
import 'package:rx_via_weather_app/model/model_command.dart';

import 'package:rx_via_weather_app/model/weather_model.dart';
import 'package:rx_via_weather_app/model/weather_repo.dart';

import 'package:rx_widgets/rx_widgets.dart';

import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

void main() {
  final repo = WeatherRepo(client: http.Client());
  final modelCommand = ModelCommand(repo);
  runApp(
    ModelProvider(
      modelCommand: modelCommand,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      title: 'Rx Weather App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: <Widget>[
          Container(
            child: Center(
              child: RxLoader<bool>(
                radius: 20.0,
                commandResults: ModelProvider.of(context).getGpsStatus$.results,
                dataBuilder: (context, data) {
                  if (!data) Geolocator().getLastKnownPosition();
                  return Text(data ? "Gps Active" : "Gps Inactive");
                },
                placeHolderBuilder: (context) => Text("Push the button"),
                errorBuilder: (context, exception) => Text('$exception'),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed: ModelProvider.of(context).getGpsStatus$,
          ),
          PopupMenuButton<int>(
            padding: EdgeInsets.all(1.0),
            tooltip: "Select number of cities",
            onSelected: (int item) {
              ModelProvider.of(context).addCities$(item);
              ModelProvider.of(context).getCurrentLocation$();
            },
            itemBuilder: (context) => menuNumbers
                .map((number) => PopupMenuItem(
                      value: number,
                      child: Center(
                        child: Text(number.toString()),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: RxLoader<List<WeatherModel>>(
              radius: 30.0,
              commandResults: ModelProvider.of(context).updateWeather$.results,
              dataBuilder: (context, data) => WeatherList(data),
              placeHolderBuilder: (context) => Center(
                    child: Text("No Data"),
                  ),
              errorBuilder: (context, error) => Center(child: Text("$error")),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: WidgetSelector(
                    buildEvents: ModelProvider.of(context)
                        .getCurrentLocation$
                        .canExecute, //This will issue `false` while the command executes
                    onTrue: MaterialButton(
                      child: Text("Get the weather"),
                      onPressed: ModelProvider.of(context).getCurrentLocation$,
                    ),
                    onFalse: MaterialButton(
                      onPressed: null,
                      child: Text('Loading...'),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 50.0),
                    child: Column(
                      children: <Widget>[
                        SliderItem(
                          sliderState: true,
                          command: ModelProvider.of(context).radioChecked$,
                        ),
                        Container(
                          child: Text("Turn off Data"),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WeatherList extends StatelessWidget {
  final List<WeatherModel> list;
  WeatherList(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                leading: Image.network("http://openweathermap.org/img/w/" +
                    list[index].iconUrl.toString() +
                    '.png'),
                title: Text(list[index].city),
                subtitle: Container(
                  padding: const EdgeInsets.all(10.0),
                  child:
                      Text('${list[index].temperature.toStringAsFixed(2)} °C'),
                ),
                trailing: Container(
                    child: Column(
                  children: <Widget>[
                    Text(list[index].description),
                    Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Latitude: ${list[index].lat}',
                        style: TextStyle(
                            fontSize: 12.0, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'Longitude: ${list[index].lng}',
                        style: TextStyle(
                            fontSize: 12.0, fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                )),
              ),
            ));
  }
}

class SliderItem extends StatefulWidget {
  final bool sliderState;
  final ValueChanged<bool>
      command; //A callback type inside flutter that tells the framework that the value has changed

  SliderItem({this.sliderState, this.command});

  createState() => SliderState(sliderState, command);
}

class SliderState extends State<SliderItem> {
  bool sliderState;
  ValueChanged<bool> command;

  SliderState(this.sliderState, this.command);

  build(context) => Switch(
        value: sliderState,
        onChanged: (item) {
          setState(() {
            sliderState = item;
          });
          command(item);
        },
      );
}

final List<int> menuNumbers = <int>[5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
