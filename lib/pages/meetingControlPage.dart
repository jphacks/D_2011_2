import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/meeting.dart';

class MeetingControlPage extends StatefulWidget {
  final Meeting meeting;
  MeetingControlPage(this.meeting);

  @override
  _MeetingControlPageState createState() => _MeetingControlPageState();
}

class _MeetingControlPageState extends State<MeetingControlPage> {
  void showTimeControlSheet(bool isPositive) {
    TextEditingController _textFieldController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text((isPositive ? "+" : "-") + '5分'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text((isPositive ? "+" : "-") + '1分'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('カスタム'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(isPositive ? "時間を追加" : "時間を減らす"),
                        content: Row(
                          children: [
                            Text(isPositive ? "+" : "-"),
                            Expanded(
                              child: TextField(
                                controller: _textFieldController,
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.numberWithOptions(),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Text("分"),
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              print(_textFieldController.value.text);
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
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
                              onPressed: () {
                                showTimeControlSheet(false);
                              },
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
                              onPressed: () {
                                showTimeControlSheet(true);
                              },
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
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              animType: AnimType.SCALE,
                              title: '確認',
                              desc: 'ミーティングを終了してよろしいですか？',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                //TODO: 終了処理
                              },
                            )..show();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
