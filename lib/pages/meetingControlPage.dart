import 'package:aika_flutter/widget/customButton.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  int _current = 5;
  String agendaTitle = "";
  Timer timer;

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
                onTap: () async {
                  final result = await ApiManager.changeTime(
                      widget.meeting.id, isPositive ? 5 : -5);
                  setState(() {
                    _current = result.duration;
                    agendaTitle = result.title;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text((isPositive ? "+" : "-") + '1分'),
                onTap: () async {
                  final result = await ApiManager.changeTime(
                      widget.meeting.id, isPositive ? 1 : -1);
                  setState(() {
                    _current = result.duration;
                    agendaTitle = result.title;
                  });
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
                            onPressed: () async {
                              int dif = isPositive
                                  ? int.parse(_textFieldController.value.text)
                                  : -(int.parse(
                                      _textFieldController.value.text));
                              final result = await ApiManager.changeTime(
                                  widget.meeting.id, dif);
                              setState(() {
                                _current = result.duration;
                                agendaTitle = result.title;
                              });
                              Navigator.of(context).pop();
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
        headerAnimationLoop: false,
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      )..show();
    }
  }

  void polling(Timer timer) async {
    try {
      final status = await ApiManager.meetingStatus(widget.meeting.id);
      if (status.title != null && status.duration >= 0) {
        setState(() {
          isAsyncCall = false;
          isEntered = true;
          _current = status.duration;
          agendaTitle = status.title;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    joinAika();

    timer = Timer.periodic(const Duration(seconds: 1), polling);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
                                    final result = await ApiManager.nextTopic(
                                        widget.meeting.id);
                                    setState(() {
                                      _current = result.duration;
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
                            agendaTitle = result.title;
                          });
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
