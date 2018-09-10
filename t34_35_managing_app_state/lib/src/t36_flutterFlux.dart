import 'package:flutter/material.dart';
import 'package:t34_35_managing_app_state/src/t36_stores.dart';
import 'package:flutter_flux/flutter_flux.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flux Example',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  createState() => HomeState();
}

//Also, nowhere in this widget we are calling `setState()`
//It's because StoreWatcherMixin
class HomeState extends State<Home> with StoreWatcherMixin<Home> {
  CoinStore store;

  bool isFetchingData = false;

  @override
  void initState() {
    super.initState();
    //store = listenToStore(coinStoreToken);
    store = listenToStore(coinStoreToken, handleStoreChanged);
  }

  void handleStoreChanged(Store store) {
    print("Inside handleStoreChanged");
    CoinStore coinStore = store;
    if (coinStore.coins.isNotEmpty) {
      setState(() {
        isFetchingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Builds HomeState ${store.coins.length}");

    return Scaffold(
        appBar: AppBar(
          title: Text("Flux example"),
          actions: <Widget>[
            isFetchingData == true
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      loadCoinsAction.call();
                      setState(() {
                        isFetchingData = true;
                      });
                    },
                    child: Text("Get coins"))
          ],
        ),
        body: ListView(
            children: store.coins.map((coin) => CoinWidget(coin)).toList()));
  }
}

class CoinWidget extends StatelessWidget {
  CoinWidget(this.coin);
  final Coin coin;
  @override
  Widget build(BuildContext context) {
    print("Builds CoinWidget");
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          // border: Border.merge(Border.all(width: 10.0, color: Colors.blue),
          //     Border.all(width: 15.0, color: Colors.red)),
          border: Border.all(width: 5.0, color: Colors.red)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              title: Text(coin.name),
              leading: CircleAvatar(
                child: Text(
                  coin.symbol,
                  style: TextStyle(fontSize: 14.0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.amber,
              ),
              subtitle: Text("\$${coin.price.toStringAsFixed(2)}"),
            ),
          )
        ],
      ),
    );
  }
}

// child: Card(
//         elevation: 4.0,
//         color: Colors.lightBlue,
//         child: ExpansionTile(
//           title: Text(coin.name),
//           leading: CircleAvatar(
//             backgroundColor: Colors.amber,
//             foregroundColor: Colors.white,
//             child: Text(coin.symbol, style: TextStyle(fontSize: 14.0)),
//           ),
//           children: <Widget>[
//             Text("\$${coin.price.toStringAsFixed(2)}"),
//           ],
//         )),

// child: Row(
//           children: <Widget>[
//             Expanded(
//               child: ListTile(
//                 title: Text(coin.name),
//                 leading: CircleAvatar(
//                   child: Text(
//                     coin.symbol,
//                     style: TextStyle(fontSize: 14.0),
//                   ),
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.amber,
//                 ),
//                 subtitle: Text("\$${coin.price.toStringAsFixed(2)}"),
//               ),
//             )
//           ],
//         ),
