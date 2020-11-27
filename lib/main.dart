import 'package:flutter/material.dart';
import 'pages/loadingPage.dart';

void main() {
  runApp(AikaApp());
}

class AikaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aika',
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xff548aff),
        accentColor: Color(0xff548aff),
        toggleableActiveColor: Color(0xff548aff),
        canvasColor: Colors.white,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        cardColor: Colors.white,
        textSelectionColor: Color(0xff548aff),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          brightness: Brightness.light,
          textTheme: TextTheme().apply(bodyColor: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color(0xff548aff),
        accentColor: Color(0xff548aff),
        toggleableActiveColor: Color(0xff548aff),
        canvasColor: Colors.black,
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[600],
        cardColor: Colors.grey[800],
        textSelectionColor: Color(0xff548aff),
        appBarTheme: AppBarTheme(
          color: Colors.grey[800],
          brightness: Brightness.dark,
          textTheme: TextTheme().apply(bodyColor: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home: LoadingPage(),
    );
  }
}
