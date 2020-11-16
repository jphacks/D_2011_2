import 'package:aika_flutter/supportingFile/zoomSdk.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import '../widget/customButton.dart';
import 'createMeetingPage.dart';
import 'onBoardingPage.dart';
import 'meetingListPage.dart';
import '../models/meeting.dart';

class WelcomePage extends StatelessWidget {
  final String userName;

  WelcomePage(this.userName);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: OverflowBox(
          maxWidth: 200,
          child: Padding(
            padding: EdgeInsets.only(left: 50),
            child: FlatButton(
              child: Text(
                "ログアウト",
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                FlutterZoomSdk.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loginpage(),
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnBoardingPage(),
                ),
              );
            },
          ),
        ],
      ),
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
            SizedBox(height: 50),
            Image.asset(
              'assets/images/meeting.png',
            ),
            SizedBox(height: 75),
            SizedBox(
              width: size.width * 0.65,
              height: size.width * 0.125,
              child: customButton(
                title: "ミーティングを作成する",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMeetingPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: size.width * 0.65,
              height: size.width * 0.125,
              child: customButton(
                title: "ミーティング一覧",
                onPressed: () {
                  // TODO: APIでミーティングリストを取得
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeetingListPage([
                        Meeting(
                            title: "Test", date: DateTime.now(), url: "Test")
                      ]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
