import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';

import 'package:redux_tutorial/model/model.dart';
import 'package:redux_tutorial/model/app_state.dart';
import 'package:redux_tutorial/redux/actions.dart';
import 'package:redux_tutorial/redux/reducers.dart';
import 'package:redux_tutorial/redux/middleware.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
      middleware: appStateMiddleware(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux List tutorial',
        theme: ThemeData.dark(),

        //StoreBuilder isn't really necessary, we are only using this because we want to pass
        //store to our Descendant widget for DevToolsStore
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(GetItemsAction()),
          builder: (context, Store<AppState> store) => Home(store),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final DevToolsStore<AppState> store;
  Home(this.store); //Not necessary though

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Redux Items")),
        drawer: Container(child: ReduxDevTools(store)),
        body: StoreConnector<AppState, _ViewModel>(
          converter: (Store<AppState> store) => _ViewModel.create(store),
          builder: (context, _ViewModel viewModel) => Column(
                children: <Widget>[
                  AddItemWidget(viewModel),
                  Expanded(child: ItemListWidget(viewModel)),
                  RemoveItemsButton(viewModel)
                ],
              ),
        ));
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;
  AddItemWidget(this.model);

  createState() => _AddItemState();
}

class _AddItemState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'add an item',
        ),
        onSubmitted: (String s) {
          widget.model.addItems(s);
          controller.text = '';
        },
      );
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;
  ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) => ListView(
        children: model.items
            .map(
              (item) => ListTile(
                    title: Text(item.body),
                    leading: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => model.removeItem(item),
                    ),
                    trailing: Checkbox(
                        value: item.completed,
                        onChanged: (b) => model.onCompleted(item)),
                  ),
            )
            .toList(),
      );
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;
  RemoveItemsButton(this.model);

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text("Delete all items"),
        onPressed: model.removeItems,
      );
}

//MiddlePiece that connects the User Interface to our Store
//We can decide what we want to expose from our store and from our UI to the other parts of the application
class _ViewModel {
  final List<Item> items;
  final Function(String) addItems;
  final Function(Item) removeItem;
  final Function() removeItems;
  final Function(Item) onCompleted;

  _ViewModel(
      {this.items,
      this.addItems,
      this.removeItem,
      this.removeItems,
      this.onCompleted});

  factory _ViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    _onCompleted(Item item) {
      store.dispatch(ItemCompletedAction(item));
    }

    return _ViewModel(
        items: store.state.items,
        addItems: _onAddItem,
        removeItem: _onRemoveItem,
        removeItems: _onRemoveItems,
        onCompleted: _onCompleted);
  }
}
