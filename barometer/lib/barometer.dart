import 'dart:async';

import 'package:flutter/services.dart';

class Barometer {
  static const MethodChannel _channel =
      const MethodChannel('barometer');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
