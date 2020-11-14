import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FlutterZoomSdk {
  static const MethodChannel _channel = const MethodChannel('flutter_zoom_sdk');

  static Future<bool> init(
      {@required String clientKey, @required String clientSecret}) async {
    final bool result = await _channel.invokeMethod('init', <String, dynamic>{
      'clientKey': clientKey,
      'clientSecret': clientSecret,
    });
    return result;
  }

  static Future<bool> isLoggedIn() async {
    final bool result = await _channel.invokeMethod('isLoggedIn');
    return result;
  }

  static Future<bool> login(
      {@required String email,
      @required String password,
      @required bool remember}) async {
    final bool result = await _channel.invokeMethod('login', <String, dynamic>{
      'email': email,
      'password': password,
      'remember': remember,
    });
    return result;
  }
  //
  // static Future<bool> login() async {
  //   final bool result = await _channel.invokeMethod('login');
  //   return result;
  // }

  static void logout() {
    _channel.invokeMethod('logout');
  }

  static Future<String> userName() async {
    final String result = await _channel.invokeMethod('userName');
    return result;
  }
}
