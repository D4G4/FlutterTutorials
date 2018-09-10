import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_flux/flutter_flux.dart';

class Coin {
  final String id;
  final String name;
  final String symbol;
  final double price; //in USD

  Coin({this.id, this.name, this.symbol, this.price});

  Coin.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        price = double.parse(json['price_usd']),
        symbol = json["symbol"];
}

//Repository
class CoinRepo {
  Future<Stream<Coin>> getCoins() async {
    String url = "https://api.coinmarketcap.com/v1/ticker/";

    var client = http.Client();
    var streamRes = await client.send(http.Request('get', Uri.parse(url)));
    print("got res");

    return streamRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((body) => (body as List))
        .map((json) => Coin.fromJson(json));
  }
}

/// Store in a flux app is just a Repository and the class that manages our app state
///
/// Convetions:
///   Typically you do not want to mutate the data inside the store
///   Instead you want to mutate it by `dispatching the actions`
///
/// Think if it as a "batch of Read-Only data"
/// So if you have any data that you want to get form the Store, you add the getter method.
class CoinStore extends Store {
  final repo = CoinRepo();

  CoinStore() {
    //A conveyance method for listening the Action
    triggerOnAction(loadCoinsAction, (dynamic nothing) async {
      var stream = await repo.getCoins();
      if (_coins.isNotEmpty) {
        _coins.clear();
      }
      stream.listen((coin) => _coins.add(coin));
    });
  }

  final List<Coin> _coins = <Coin>[];

  List<Coin> get coins => List<Coin>.unmodifiable(_coins);
}

//The only thing that is mutating the store is this action
final Action loadCoinsAction = Action();

//Allows us to attach listener to our Store
final StoreToken coinStoreToken = StoreToken(CoinStore());
