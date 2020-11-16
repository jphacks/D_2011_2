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

  static Future<Meeting> createMeeting(
      {@required String title,
      @required DateTime date,
      @required bool beforeHost,
      @required bool waitingRoom,
      @required int duration}) async {
    final unixTime = date.toUtc().millisecondsSinceEpoch ~/ 1000;
    final String result =
        await _channel.invokeMethod('createMtg', <String, dynamic>{
      'title': title,
      'date': unixTime,
      'beforeHost': beforeHost,
      'waitingRoom': waitingRoom,
      'duration': duration,
    });
    final meetingInfo = result.split(",");
    return Meeting(id: meetingInfo[0], password: meetingInfo[1]);
  }

  static void logout() {
    _channel.invokeMethod('logout');
  }

  static Future<String> userName() async {
    final String result = await _channel.invokeMethod('userName');
    return result;
  }
}

class Meeting {
  final String id;
  final String password;

  Meeting({@required this.id, @required this.password});
}
