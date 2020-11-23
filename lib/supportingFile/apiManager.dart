import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/agenda.dart';

class ApiManager {
  static const String baseUrl = "https://aika.lit-kansai-mentors.com";

  static Future<CreateMeetingResponse> createZoomMeeting(
      CreateMeetingParams params) async {
    final response = await http.post(baseUrl + "/api/meeting",
        body: jsonEncode(params),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return CreateMeetingResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}

class CreateMeetingResponse {
  final String url;
  final String id;

  CreateMeetingResponse(this.url, this.id);

  factory CreateMeetingResponse.fromJson(Map<String, dynamic> json) {
    return CreateMeetingResponse(
      json["data"]["uel"].toString(),
      json["data"]["id"].toString(),
    );
  }
}

class CreateMeetingParams {
  final String title;
  final int startTime;
  final String zoomId;
  final String pass;
  final List<Agenda> agendas;

  CreateMeetingParams({
    @required this.title,
    @required this.startTime,
    @required this.zoomId,
    @required this.pass,
    @required this.agendas,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'start_time': startTime,
        'zoom_id': zoomId,
        'zoom_pass': pass,
        'agendas': agendas,
      };
}
