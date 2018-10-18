import 'dart:async';
import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:redux_tutorial/model/app_state.dart';
import 'package:redux_tutorial/redux/actions.dart';

///[NextDispatcher] :: a function :: chain this middleware
///with next on (if any) or to our reducer.
///If we have an action that gets dispatched to this piece of middleware
///but it doesn not get assigned to any other piece of middleware,
///then it will automatically be send to our reducer

List<Middleware<AppState>> appStateMiddleware([
  AppState state = const AppState(items: []),
]) {
  final loadItems = _loadFromPrefs(state);
  final saveItems = _saveToPrefs(state);
  return [
    //Create Middleware by binding these functions to the actions
    TypedMiddleware<AppState, AddItemAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemsAction>(saveItems),
    TypedMiddleware<AppState, GetItemsAction>(loadItems),
  ];
}

///The following functions returns MiddlewareClosure
Middleware<AppState> _loadFromPrefs(AppState state) {
  print("_loadFromPrefs");
  return (Store<AppState> store, action, NextDispatcher next) {
    print(
        "Middleware Returning from _loadFromPrefs ${action.runtimeType.toString()}");
    next(action);
    loadFromPrefs()
        .then((state) => store.dispatch(ItemsLoadedAction(state.items)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state) {
  print("_saveToPrefs");
  return (Store<AppState> store, action, NextDispatcher next) {
    print("savingToPrefs");
    next(action);
    saveAndReplaceToPrefs(store.state);
  };
}

//Internal middleware methods
void saveAndReplaceToPrefs(AppState state) async {
  print("saveAndReplaceToPrefs");
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var jsonStr = json.encode(state.toJson());
  await preferences.setString('itemState', jsonStr);
  print("Saved into prefs");
}

Future<AppState> loadFromPrefs() async {
  print("loadFromPrefs()");
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var jsonStr = preferences.getString(("itemState"));
  if (jsonStr != null) {
    print("Json string is not null  \n $jsonStr");
    return AppState.fromJson(json.decode(jsonStr));
  } else {
    print("Got nothing from shared prefs");
  }
  return AppState.initialState();
}

// void appStateMiddleware(
//     Store<AppState> store, action, NextDispatcher next) async {
//   next(action);

//   switch (action.runtimeType) {
//     case AddItemAction:
//     case RemoveItemAction:
//     case RemoveItemsAction:
//       saveAndReplaceToPrefs(store.state);
//       break;

//     case GetItemsAction:
//       await loadFromPrefs()
//           .then((state) => store.dispatch(LoadedItemsAction(state.items)));
//       break;
//   }
// }

//Typed Middleware are is pretty useful because it allows us to essentially take
//the concerns of our middleware and tie them to individual pieces of middleware and
//chain them together.
//Makes our Middleware much more redable.
