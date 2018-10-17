import 'package:redux_tutorial/model/model.dart';

class AddItemAction {
  static int _id = 0;
  final String item;

  AddItemAction(this.item) {
    _id++;
  }

  int get id => _id;
}

class RemoveItemAction {
  final Item item;

  RemoveItemAction(this.item);
}

class RemoveItemsAction {}

class GetItemsAction {}

class ItemsLoadedAction {
  final List<Item> items;

  ItemsLoadedAction(this.items);
}

class ItemCompletedAction {
  final Item item;
  ItemCompletedAction(this.item);
}
