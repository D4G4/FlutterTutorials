// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starship.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new

Serializer<Starship> _$starshipSerializer = new _$StarshipSerializer();
Serializer<Result> _$resultSerializer = new _$ResultSerializer();

class _$StarshipSerializer implements StructuredSerializer<Starship> {
  @override
  final Iterable<Type> types = const [Starship, _$Starship];
  @override
  final String wireName = 'Starship';

  @override
  Iterable serialize(Serializers serializers, Starship object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'count',
      serializers.serialize(object.count, specifiedType: const FullType(int)),
      'results',
      serializers.serialize(object.results,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Result)])),
    ];
    if (object.next != null) {
      result
        ..add('next')
        ..add(serializers.serialize(object.next,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Starship deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StarshipBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'count':
          result.count = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'next':
          result.next = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'results':
          result.results.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Result)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$ResultSerializer implements StructuredSerializer<Result> {
  @override
  final Iterable<Type> types = const [Result, _$Result];
  @override
  final String wireName = 'Result';

  @override
  Iterable serialize(Serializers serializers, Result object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.model != null) {
      result
        ..add('model')
        ..add(serializers.serialize(object.model,
            specifiedType: const FullType(String)));
    }
    if (object.manufacturer != null) {
      result
        ..add('manufacturer')
        ..add(serializers.serialize(object.manufacturer,
            specifiedType: const FullType(String)));
    }
    if (object.starshipClass != null) {
      result
        ..add('starshipClass')
        ..add(serializers.serialize(object.starshipClass,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Result deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ResultBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'model':
          result.model = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'manufacturer':
          result.manufacturer = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'starshipClass':
          result.starshipClass = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Starship extends Starship {
  @override
  final int count;
  @override
  final String next;
  @override
  final BuiltList<Result> results;

  factory _$Starship([void updates(StarshipBuilder b)]) =>
      (new StarshipBuilder()..update(updates)).build();

  _$Starship._({this.count, this.next, this.results}) : super._() {
    if (count == null) throw new BuiltValueNullFieldError('Starship', 'count');
    if (results == null)
      throw new BuiltValueNullFieldError('Starship', 'results');
  }

  @override
  Starship rebuild(void updates(StarshipBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  StarshipBuilder toBuilder() => new StarshipBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Starship &&
        count == other.count &&
        next == other.next &&
        results == other.results;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, count.hashCode), next.hashCode), results.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Starship')
          ..add('count', count)
          ..add('next', next)
          ..add('results', results))
        .toString();
  }
}

class StarshipBuilder implements Builder<Starship, StarshipBuilder> {
  _$Starship _$v;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  String _next;
  String get next => _$this._next;
  set next(String next) => _$this._next = next;

  ListBuilder<Result> _results;
  ListBuilder<Result> get results =>
      _$this._results ??= new ListBuilder<Result>();
  set results(ListBuilder<Result> results) => _$this._results = results;

  StarshipBuilder();

  StarshipBuilder get _$this {
    if (_$v != null) {
      _count = _$v.count;
      _next = _$v.next;
      _results = _$v.results?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Starship other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$Starship;
  }

  @override
  void update(void updates(StarshipBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Starship build() {
    _$Starship _$result;
    try {
      _$result = _$v ??
          new _$Starship._(count: count, next: next, results: results.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'results';
        results.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Starship', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Result extends Result {
  @override
  final String name;
  @override
  final String model;
  @override
  final String manufacturer;
  @override
  final String starshipClass;

  factory _$Result([void updates(ResultBuilder b)]) =>
      (new ResultBuilder()..update(updates)).build();

  _$Result._({this.name, this.model, this.manufacturer, this.starshipClass})
      : super._();

  @override
  Result rebuild(void updates(ResultBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ResultBuilder toBuilder() => new ResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Result &&
        name == other.name &&
        model == other.model &&
        manufacturer == other.manufacturer &&
        starshipClass == other.starshipClass;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, name.hashCode), model.hashCode), manufacturer.hashCode),
        starshipClass.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Result')
          ..add('name', name)
          ..add('model', model)
          ..add('manufacturer', manufacturer)
          ..add('starshipClass', starshipClass))
        .toString();
  }
}

class ResultBuilder implements Builder<Result, ResultBuilder> {
  _$Result _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _model;
  String get model => _$this._model;
  set model(String model) => _$this._model = model;

  String _manufacturer;
  String get manufacturer => _$this._manufacturer;
  set manufacturer(String manufacturer) => _$this._manufacturer = manufacturer;

  String _starshipClass;
  String get starshipClass => _$this._starshipClass;
  set starshipClass(String starshipClass) =>
      _$this._starshipClass = starshipClass;

  ResultBuilder();

  ResultBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _model = _$v.model;
      _manufacturer = _$v.manufacturer;
      _starshipClass = _$v.starshipClass;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Result other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$Result;
  }

  @override
  void update(void updates(ResultBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Result build() {
    final _$result = _$v ??
        new _$Result._(
            name: name,
            model: model,
            manufacturer: manufacturer,
            starshipClass: starshipClass);
    replace(_$result);
    return _$result;
  }
}
