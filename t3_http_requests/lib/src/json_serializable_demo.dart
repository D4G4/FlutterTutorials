import 'package:json_annotation/json_annotation.dart';

part 'json_serializable_demo.g.dart';

@JsonSerializable()
class User extends Object with _$UserSerializerMixin {
  User(this.counttt);

  @JsonKey(name: 'count', nullable: true)
  final int counttt;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
