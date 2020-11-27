import 'package:aika_flutter/widget/customButton.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:quiver/async.dart';
import '../models/meeting.dart';
import '../supportingFile/apiManager.dart';

class MeetingControlPage extends StatefulWidget {
  final Meeting meeting;
  MeetingControlPage(this.meeting);

  @override
  _MeetingControlPageState createState() => _MeetingControlPageState();
}

class _MeetingControlPageState extends State<MeetingControlPage> {
  bool isEntered = false;
  bool isAsyncCall = false;

  int _start = 5;
  int _current = 5;

  String agendaTitle = "";

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      sub.cancel();
      _current = 0;
    });
  }

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
                  // TODO: 時間変更処理
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text((isPositive ? "+" : "-") + '1分'),
                onTap: () {
                  // TODO: 時間変更処理
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
                              // TODO: 時間変更処理
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

  void joinAika() async {
    setState(() {
      isAsyncCall = true;
    });
    final success = await ApiManager.joinMeeting(widget.meeting.id);
    setState(() {
      isAsyncCall = false;
    });
    if (!success) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: 'エラー',
        desc: 'Aikaがミーティングに参加できませんでした。',
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }

  void _onTimer(Timer timer) async {
    final status = await ApiManager.meetingStatus(widget.meeting.id);

    if (status != null) {
      setState(() {
        isAsyncCall = false;
        isEntered = true;
        _current = status.duration;
        _start = status.duration;
        agendaTitle = status.title;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    joinAika();

    Timer.periodic(const Duration(seconds: 5), _onTimer);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ModalProgressHUD(
        inAsyncCall: isAsyncCall,
        child: Scaffold(
          body: SafeArea(
            child: isEntered
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
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
                                agendaTitle,
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
                                    "${_current ~/ 60}:${(_current % 60).toString().padLeft(2, "0")}",
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
                                      color: Theme.of(context).accentColor,
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
                                  color: Theme.of(context).accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      isAsyncCall = true;
                                    });
                                    final result =
                                        await ApiManager.startMeeting(
                                            widget.meeting.id);
                                    setState(() {
                                      _current = result.duration;
                                      _start = result.duration;
                                      agendaTitle = result.title;
                                    });
                                    setState(() {
                                      isAsyncCall = false;
                                    });
                                  },
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
                                        ApiManager.finishMeeting(
                                            widget.meeting.id);
                                        Navigator.of(context).pop();
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
                  )
                : Center(
                    child: SizedBox(
                      width: 300,
                      height: 75,
                      child: CustomButton(
                        title: "ミーティングを始める",
                        onPressed: () async {
                          final result =
                              await ApiManager.startMeeting(widget.meeting.id);
                          setState(() {
                            _current = result.duration;
                            _start = result.duration;
                            agendaTitle = result.title;
                          });
                          startTimer();
                          setState(() {
                            isEntered = true;
                          });
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
