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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bannar-light.png',
              width: size.width / 1.5,
            ),
            SizedBox(height: 200),
            CircularProgressIndicator(),
            // SizedBox(height: 15.0),
            // Text("Loading"),
          ],
        ),
      ),
    );
  }
}
