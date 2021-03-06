import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/agenda.dart';
import '../models/meeting.dart';

class ApiManager {
  static const String _baseUrl = "https://aika.lit-kansai-mentors.com";

  static Future<CreateMeetingResponse> createZoomMeeting(
      CreateMeetingParams params) async {
    final response = await http.post(
      _baseUrl + "/api/meeting",
      body: jsonEncode(params),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return CreateMeetingResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Suggestion>> suggestion(String keyword) async {
    final response =
        await http.get(_baseUrl + "/api/meeting/template/$keyword");
    if (response.statusCode == 200) {
      final List<Suggestion> result = [];
      final List<dynamic> rawData =
          jsonDecode(utf8.decode(response.bodyBytes))["data"]["suggestion"];
      for (Map<String, dynamic> json in rawData) {
        final suggestion = Suggestion.fromJson(json);
        result.add(suggestion);
      }
      return result;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<bool> joinMeeting(String id) async {
    final response = await http.post(_baseUrl + "/api/meeting/$id/join");
    return response.statusCode == 200;
  }

  static Future<OnGoingAgenda> startMeeting(String id) async {
    final response = await http.post(_baseUrl + "/api/meeting/$id/start");
    return OnGoingAgenda.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  static Future<bool> finishMeeting(String id) async {
    final response = await http.post(_baseUrl + "/api/meeting/$id/finish");
    return response.statusCode == 200;
  }

  static String agendaImageUrl(String id) {
    return _baseUrl + "/api/meeting/$id/agenda/list.png";
  }

  static Future<OnGoingAgenda> nextTopic(String id) async {
    final response = await http.post(_baseUrl + "/api/meeting/$id/agenda/next");
    return OnGoingAgenda.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  static Future<List<Meeting>> meetingList(String email) async {
    var params = {'email': email};
    final response = await http.post(
      _baseUrl + "/api/meeting/find",
      body: jsonEncode(params),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> rawData =
          jsonDecode(utf8.decode(response.bodyBytes))["data"];
      List<Meeting> meetings = [];

      for (int i = 0; i < rawData.length; i++) {
        final date = new DateTime.fromMillisecondsSinceEpoch(
            int.parse(rawData[i]["start_time"].toString()) * 1000);
        final meeting = Meeting(
            id: rawData[i]["meeting_id"].toString(),
            title: rawData[i]["title"].toString(),
            date: date,
            url:
                "https://aika.lit-kansai-mentors.com/agenda/${rawData[i]["meeting_id"].toString()}");
        meetings.add(meeting);
      }
      return meetings;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<OnGoingAgenda> meetingStatus(String id) async {
    final response = await http.get(_baseUrl + "/api/meeting/$id/status");
    if (response.statusCode == 200) {
      return OnGoingAgenda.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      return null;
    }
  }

  static Future<OnGoingAgenda> changeTime(String id, int dif) async {
    final Map<String, dynamic> params = {"dif": dif * 60};
    final response = await http.post(
      _baseUrl + "/api/meeting/$id/reschedule",
      body: jsonEncode(params),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return OnGoingAgenda.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw null;
    }
  }
}

class Suggestion {
  final String title;
  final List<Agenda> agendas;

  Suggestion(this.title, this.agendas);

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    final List<dynamic> agendasRaw = json["agendas"];
    final List<Agenda> agendaList = [];

    for (Map<String, dynamic> rawJson in agendasRaw) {
      final agenda = Agenda(
        title: rawJson["content"].toString(),
        min: int.parse(rawJson["duration"].toString()) ~/ 60,
      );
      agendaList.add(agenda);
    }

    return Suggestion(
      json["title"].toString(),
      agendaList,
    );
  }
}

class OnGoingAgenda {
  final String title;
  final int duration;

  OnGoingAgenda(this.title, this.duration);

  factory OnGoingAgenda.fromJson(Map<String, dynamic> json) {
    final date = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(json["data"]["duration"].toString()) * 1000);
    return OnGoingAgenda(
      json["data"]["title"].toString(),
      date.difference(DateTime.now()).inSeconds,
    );
  }
}

class CreateMeetingResponse {
  final String url;
  final String id;

  CreateMeetingResponse(this.url, this.id);

  factory CreateMeetingResponse.fromJson(Map<String, dynamic> json) {
    return CreateMeetingResponse(
      json["data"]["url"].toString(),
      json["data"]["id"].toString(),
    );
  }
}

class CreateMeetingParams {
  final String title;
  final int startTime;
  final String zoomId;
  final String pass;
  final String email;
  final List<Agenda> agendas;

  CreateMeetingParams({
    @required this.title,
    @required this.startTime,
    @required this.zoomId,
    @required this.pass,
    @required this.email,
    @required this.agendas,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'start_time': startTime,
        'zoom_id': zoomId,
        'zoom_pass': pass,
        'email': email,
        'agendas': agendas,
      };
}
