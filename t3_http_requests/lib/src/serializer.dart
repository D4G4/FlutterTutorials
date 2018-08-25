//Once per app, a top level "Serializer"

import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'starship.dart'; //required to tell which class needs to be serialized
import 'package:built_value/standard_json_plugin.dart';

part 'serializer.g.dart';

//@SerializersFor(const [Starship, Result])
@SerializersFor(const [Starship])
final Serializers serializers = (_$serializers.toBuilder()
  ..addPlugin(StandardJsonPlugin())).build();
