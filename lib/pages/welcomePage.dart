import 'package:aika_flutter/supportingFile/zoomSdk.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';

class WelcomePage extends StatelessWidget {
  final String userName;

  WelcomePage(this.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello! $userName"),
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
