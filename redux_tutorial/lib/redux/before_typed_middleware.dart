import 'dart:async';
import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:redux_tutorial/model/app_state.dart';
import 'package:redux_tutorial/redux/actions.dart';

//Internal middleware methods
void saveAndReplaceToPrefs(AppState state) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var jsonStr = json.encode(state.toJson());
  await preferences.setString('itemState', jsonStr);
}

Future<AppState> loadFromPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var jsonStr = preferences.getString(("itemState"));
  if (jsonStr != null) {
    return AppState.fromJson(json.decode(jsonStr));
  }
  return AppState.initialState();
}

///[NextDispatcher] :: a function :: chain this middleware
///with next on (if any) or to our reducer.
///If we have an action that gets dispatched to this piece of middleware
///but it doesn not get assigned to any other piece of middleware,
///then it will automatically be send to our reducer
void appStateMiddleware(
    Store<AppState> store, action, NextDispatcher next) async {
  next(action);

  switch (action.runtimeType) {
    case AddItemAction:
    case RemoveItemAction:
    case RemoveItemsAction:
      saveAndReplaceToPrefs(store.state);
      break;

    case GetItemsAction:
      await loadFromPrefs()
          .then((state) => store.dispatch(LoadedItemsAction(state.items)));
      break;
  }
}

//Typed Middleware are is pretty useful because it allows us to essentially take
//the concerns of our middleware and tie them to individual pieces of middleware and
//chain them together.
//Makes our Middleware much more redable.
