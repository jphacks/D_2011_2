import 'package:aika_flutter/supportingFile/zoomSdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'welcomePage.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String email = "";
  String pass = "";
  bool remember = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
              left: size.width / 7,
              right: size.width / 7,
              top: size.height / 5,
              bottom: size.height / 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/bannar-light.png',
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign in with "),
                      Image.asset(
                        'assets/images/zoom_logo.png',
                        height: size.height / 60,
                      ),
                    ],
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Email", hintText: "example@example.com"),
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      email = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    autocorrect: false,
                    onChanged: (text) {
                      pass = text;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ログイン情報を記録する"),
                      Switch(
                          value: remember,
                          onChanged: (val) {
                            setState(() {
                              remember = val;
                            });
                          }),
                    ],
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                    onPressed: () async {
                      final result = await FlutterZoomSdk.login(
                        email: email,
                        password: pass,
                        remember: remember,
                      );
                      if (result) {
                        final userName = await FlutterZoomSdk.userName();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomePage(userName),
                          ),
                        );
                      }
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                        "ログイン",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.5,
                        ),
                      )),
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FlatButton(
                    onPressed: () {},
                    child: Text(
                      "アカウントをお持ちでない場合",
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
