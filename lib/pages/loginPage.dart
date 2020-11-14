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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login"),
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
                  Text("Remember Me"),
                  Switch(
                      value: remember,
                      onChanged: (val) {
                        setState(() {
                          remember = val;
                        });
                      }),
                ],
              ),
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
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
