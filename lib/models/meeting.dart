import 'package:flutter/foundation.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class Meeting {
  final String title;
  final DateTime date;
  final String url;

  Meeting({
    @required this.title,
    @required this.date,
    @required this.url,
  });

  String formatDate() {
    initializeDateFormatting("ja_JP");
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    var formatted = formatter.format(date);
    return formatted;
  }
}
