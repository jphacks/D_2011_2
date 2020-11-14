import 'package:aika_flutter/supportingFile/zoomSdk.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';

class WelcomePage extends StatelessWidget {
  final String userName;

  WelcomePage(this.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "こんにちは",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Center(
              child: Text(
                "$userName さん",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                FlutterZoomSdk.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loginpage(),
                  ),
                );
              },
              child: Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
