import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); //Notifying state tree
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
