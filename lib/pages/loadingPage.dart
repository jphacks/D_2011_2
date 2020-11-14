import 'package:flutter/material.dart';
import 'dart:async';
import 'loginPage.dart';
import 'package:aika_flutter/supportingFile/zoomSdk.dart';
import 'welcomePage.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void waiting() async {
    await Future.delayed(Duration(seconds: 2)).then((_) async {
      final isLoggedIn = await FlutterZoomSdk.isLoggedIn();
      print(isLoggedIn);
      if (isLoggedIn) {
        final userName = await FlutterZoomSdk.userName();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePage(userName),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Loginpage(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    waiting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Loading"),
              SizedBox(height: 15.0),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
