import 'package:flutter/material.dart';

import 'package:t38_41_weatherapp/model/model.dart';
import 'package:t38_41_weatherapp/model/model_provider.dart';
import 'package:t38_41_weatherapp/model/weather_repo.dart';
import 'package:t38_41_weatherapp/model/model_command.dart';

import 'package:rx_widgets/rx_widgets.dart';
import 'package:charcode/charcode.dart' as charcode;

import 'package:http/http.dart' as http;

void main() {
  final repo = WeatherRepo(client: http.Client());
  final modelCommand = ModelCommand(repo);
  runApp(ModelProvider(
    child: MyApp(),
    modelCommand: modelCommand,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Know your weather"),
        actions: <Widget>[
          Container(
            child: Center(
              child: RxLoader<bool>(
                radius: 20.0,
                commandResults: ModelProvider.of(context).commandGetGps.results,
                //dataBuilder: (BuildContext context,bool data) => Icon(data ? Icons.gps_fixed : Icons.gps_not_fixed),
                dataBuilder: (BuildContext context, bool data) =>
                    Text(data ? "Fixed" : "Nope"),
                placeHolderBuilder: (context) => Text("Push the button"),
                errorBuilder: (context, exception) => Text("$exception"),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed: ModelProvider.of(context).commandGetGps,
          ),
          PopupMenuButton<int>(
            padding: const EdgeInsets.all(1.0),
            tooltip: "Select how much data you want",
            onSelected: (int item) {
              ModelProvider.of(context).commandAddCities(item);
            },
            itemBuilder: (context) {
              return menuNumbers
                  .map((number) => PopupMenuItem(
                      value: number,
                      child: Center(
                        child: Text(number.toString()),
                      )))
                  .toList();
            },
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Expanded(
            child: RxLoader<List<WeatherModel>>(
              radius: 30.0,
              commandResults:
                  ModelProvider.of(context).commandUpdateWeather.results,
              dataBuilder: (context, data) => WeatherList(data),
              placeHolderBuilder: (context) => Center(child: Text("No data")),
              errorBuilder: (context, exception) => Center(
                    child: Text("$exception"),
                  ),
            ),
          ),
          Center(
            child: WidgetSelector(
                buildEvents:
                    ModelProvider.of(context).commandUpdateWeather.canExecute,
                onTrue: MaterialButton(
                  elevation: 5.0,
                  color: Colors.blueGrey,
                  onPressed: ModelProvider.of(context)
                      .commandGetCurrentLocation
                      .execute,
                  child: Text("Get the weather",
                      style: TextStyle(color: Colors.white)),
                ),
                onFalse: FlatButton(
                  color: Colors.blueGrey,
                  onPressed: null,
                  child: Text('Please turn on data...'),
                )),
          ),
          Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  SliderItem(
                    sliderState: true,
                    command: ModelProvider.of(context).commandRadioChecked,
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Turn off data"))
                ],
              ),
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
  final ValueChanged<bool> command;

  SliderItem({this.sliderState, this.command}) {
    print('SliderItem constructor called $sliderState $command');
  }

  @override
  SliderState createState() => SliderState(sliderState, command);
}

class SliderState extends State<SliderItem> {
  bool sliderState;
  ValueChanged<bool> command;

  SliderState(this.sliderState, this.command) {
    print('SliderState constructor called $sliderState $command');
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: sliderState,
      onChanged: (item) {
        setState(() {
          sliderState = item;
          command(item);
        });
      },
    );
  }
}
