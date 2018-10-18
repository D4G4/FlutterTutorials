import 'package:redux_tutorial/model/model.dart';
import 'package:redux_tutorial/model/app_state.dart';
import 'package:redux_tutorial/redux/actions.dart';

import 'package:redux/redux.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    items: itemReducer(state.items, action),
  );
}

Reducer<List<Item>> itemReducer = combineReducers<List<Item>>([
  TypedReducer<List<Item>, AddItemAction>(addItemReducer),
  TypedReducer<List<Item>, RemoveItemAction>(removeItemReducer),
  TypedReducer<List<Item>, RemoveItemsAction>(removeItemsReducer),
  TypedReducer<List<Item>, ItemsLoadedAction>(loadItemReducer),
  TypedReducer<List<Item>, ItemCompletedAction>(itemCompletedReducer)
]);

List<Item> addItemReducer(List<Item> items, AddItemAction action) {
  return []
    ..addAll(items)
    ..add(Item(id: action.id, body: action.item));
}

List<Item> removeItemReducer(List<Item> items, RemoveItemAction action) {
  return List.unmodifiable(List.from(items)..remove(action.item));
}

List<Item> removeItemsReducer(List<Item> items, RemoveItemsAction action) {
  return [];
}

List<Item> loadItemReducer(List<Item> items, ItemsLoadedAction action) {
  return action.items;
}

List<Item> itemCompletedReducer(List<Item> items, ItemCompletedAction action) {
  return items
      .map((item) => item.id == action.item.id
          ? item.copyWith(completed: !item.completed)
          : item)
      .toList();
}

// //Will allow us to manipulate multiple items
// List<Item> itemReducer(List<Item> state, action) {
//   print("Reducer ${action.runtimeType.toString()}");
//   switch (action.runtimeType) {
//     case AddItemAction:
//       return []
//         ..addAll(state)
//         ..add(Item(id: action.id, body: action.item));

//     case RemoveItemAction:
//       return List.unmodifiable(List.from(state)..remove(action.item));

//     case RemoveItemsAction:
//       return List.unmodifiable([]);

//     case LoadedItemsAction:
//       return action.items;

//     case ItemCompletedAction:

//     default:
//       return state;
//   }

//   // if (action is AddItemAction) {
//   //   return []
//   //     ..addAll(state)
//   //     ..add(Item(id: action.id, body: action.item));
//   // }

//   // if (action is RemoveItemAction) {
//   //   return List.unmodifiable(List.from(state)..remove(action.item));
//   // }

//   // if (action is RemoveItemsAction) {
//   //   return List.unmodifiable([]);
//   // }

//   //return state;
// }
