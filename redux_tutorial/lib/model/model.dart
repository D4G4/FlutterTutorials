import 'package:flutter/foundation.dart';

class Item {
  final int id;
  final String body;
  final bool completed;

  Item({
    @required this.id,
    @required this.body,
    this.completed = false,
  });

  //To keep consistent redux way of doing things
  //To have immutable state
  Item copyWith({int id, String body}) {
    return Item(
        id: id ?? this.id,
        body: body ?? this.body,
        completed: completed ?? this.completed);
  }

  Item.fromJson(Map json)
      : body = json['body'],
        id = json['id'],
        completed = json['completed'];

  Map toJson() => {
        'id': (id),
        'body': body,
        'completed': completed,
      };
}
