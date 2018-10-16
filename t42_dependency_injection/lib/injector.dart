import 'package:t42_dependency_injection/photo_repo.dart';
import 'package:t42_dependency_injection/mock_repo.dart';
import 'package:t42_dependency_injection/prod_repo.dart';

import 'package:http/http.dart' as http;

enum RepoType { MOCK, PROD }

class Injector {
  static final Injector _singleton = Injector._internal();

  static RepoType _dataType;

  static void configure(RepoType dataType) {
    _dataType = dataType;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  PhotoRepo get photoRepo {
    switch (_dataType) {
      case RepoType.MOCK:
        return MockRepo();
      default:
        return ProdRepo();
    }
  }
}
