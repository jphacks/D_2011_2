import 'package:flutter/foundation.dart';

class Meeting {
  final String title;
  final DateTime date;
  final String url;

  Meeting({
    @required this.title,
    @required this.date,
    @required this.url,
  });
}
