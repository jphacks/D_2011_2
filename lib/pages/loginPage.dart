import 'package:aika_flutter/supportingFile/zoomSdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'welcomePage.dart';
import '../widget/customButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String email = "";
  String pass = "";
  bool remember = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height / 7, horizontal: size.width / 7),
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
                    Platform.isIOS
                        ? Row(
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
                          )
                        : SizedBox(height: 10),
                    SizedBox(height: 10),
                    SizedBox(
                      width: size.width * 0.5,
                      height: size.width * 0.125,
                      child: CustomButton(
                        title: "ログイン",
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          final result = await FlutterZoomSdk.login(
                            email: email,
                            password: pass,
                            remember: remember,
                          );
                          setState(() {
                            loading = false;
                          });
                          if (result) {
                            final userName = await FlutterZoomSdk.userName();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomePage(userName),
                              ),
                            );
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.SCALE,
                              headerAnimationLoop: false,
                              title: '認証エラー',
                              desc: 'メールアドレス・パスワードをお確かめの上、もういちどお試しください。',
                              btnOkOnPress: () {},
                            )..show();
                          }
                        },
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
      ),
    );
  }
}
