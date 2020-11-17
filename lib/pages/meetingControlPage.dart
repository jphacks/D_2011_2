import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/meeting.dart';

class MeetingControlPage extends StatefulWidget {
  final Meeting meeting;
  MeetingControlPage(this.meeting);

  @override
  _MeetingControlPageState createState() => _MeetingControlPageState();
}

class _MeetingControlPageState extends State<MeetingControlPage> {
  void showConfirm({@required Function onOk}) {
    Widget _buildSignOutDialogAndroid() {
      return AlertDialog(
        title: Text("確認"),
        content: Text("ミーティングを終了してよろしいですか？"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "キャンセル",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("はい"),
            onPressed: onOk,
          ),
        ],
      );
    }

    Widget _buildSignOutDialogiOS() {
      return CupertinoAlertDialog(
        title: Text("確認"),
        content: Text("ミーティングを終了してよろしいですか？"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("キャンセル"),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: Text("はい"),
            isDefaultAction: true,
            onPressed: onOk,
          ),
        ],
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return Platform.isIOS
            ? _buildSignOutDialogiOS()
            : _buildSignOutDialogAndroid();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.meeting.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.meeting.formatDate() + "~",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Agenda Title",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: RaisedButton(
                              child: Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.red,
                              shape: CircleBorder(),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(width: 30),
                          Text(
                            "10:00",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 30),
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: RaisedButton(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.blueAccent,
                              shape: CircleBorder(),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 225,
                        height: 50,
                        child: RaisedButton(
                          child: Text(
                            '次の議題',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: 225,
                        height: 50,
                        child: RaisedButton(
                          child: Text(
                            '終了',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: () {
                            showConfirm(onOk: () {
                              // TODO: 終了リクエストを送る
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
