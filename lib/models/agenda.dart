import 'package:flutter/foundation.dart';

class Agenda {
  String title;
  int min;

  Agenda({@required this.title, @required this.min});

  Map<String, dynamic> toJson() => {
        'title': title,
        'duration': min * 60,
      };
}
